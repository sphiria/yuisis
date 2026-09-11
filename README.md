# yuisis

## A mediawiki docker image for gbf.wiki


Update the dependency lock using Docker and the MediaWiki build environment:

```sh
./update-composer-lock.sh sphiria/frauxsearch
```

Omit package names to update all dependencies. Review and commit `composer.lock`
alongside changes to `composer.json`.
