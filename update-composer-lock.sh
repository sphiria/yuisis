#!/usr/bin/env bash
set -euo pipefail

if [[ ${1:-} == --help || ${1:-} == -h ]]; then
    printf 'Usage: %s [package ...]\nUpdates composer.lock using the MediaWiki build environment.\nOmit package names to update all dependencies.\n' "$0"
    exit 0
fi
for package in "$@"; do
    if [[ $package == -* || $package != */* ]]; then
        printf 'Expected a Composer package name, got: %s\n' "$package" >&2
        exit 2
    fi
done

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
temp_dir=$(mktemp -d)
container_id=
cleanup() {
    if [[ -n $container_id ]]; then docker rm -f "$container_id" >/dev/null; fi
    rm -rf -- "$temp_dir"
}
trap cleanup EXIT

docker build --target mediawiki-source --iidfile "$temp_dir/image-id" "$repo_dir"
container_id=$(docker create --env COMPOSER_ALLOW_SUPERUSER=1 \
    "$(cat "$temp_dir/image-id")" \
    sh -ec '
        composer() { /usr/bin/php84 /usr/bin/composer.phar "$@"; }
        composer config --no-plugins allow-plugins.composer/installers true
        cp composer.lock /tmp/composer.original.lock
        composer update --no-dev --prefer-dist --ignore-platform-reqs --no-interaction --no-scripts "$@"
        cp /tmp/composer.original.lock composer.lock
        composer update --no-dev --prefer-dist --ignore-platform-reqs --no-interaction --no-scripts "$@"
        composer install --dry-run --no-dev --ignore-platform-reqs --no-interaction --no-scripts
    ' -- "$@")
docker cp "$repo_dir/composer.json" "$container_id:/var/www/html/composer.local.json"
docker cp "$repo_dir/composer.lock" "$container_id:/var/www/html/composer.lock"
docker start --attach "$container_id"
exit_code=$(docker inspect --format '{{.State.ExitCode}}' "$container_id")
if [[ $exit_code != 0 ]]; then
    printf 'Composer failed (exit %s); composer.lock was not replaced.\n' "$exit_code" >&2
    exit 1
fi
docker cp "$container_id:/var/www/html/composer.lock" "$temp_dir/composer.lock"
cat "$temp_dir/composer.lock" > "$repo_dir/composer.lock"
printf 'Updated %s/composer.lock\n' "$repo_dir"
