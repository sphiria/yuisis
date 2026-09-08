<?php
// SPDX-License-Identifier: GPL-2.0-or-later
declare(strict_types=1);

require '/var/www/html/vendor/autoload.php';
require __DIR__ . '/upstream/src/RedisJobChronService.php';

foreach (['redis', 'pcntl'] as $extension) {
    if (!extension_loaded($extension)) {
        fwrite(STDERR, "Missing PHP extension: $extension\n");
        exit(1);
    }
}

$server = trim((string)getenv('REDIS_HOST'));
if ($server === '') {
    fwrite(STDERR, "REDIS_HOST must identify the wiki's Redis job server.\n");
    exit(1);
}
$address = Wikimedia\IPUtils::splitHostAndPort($server);
if ($address === false) {
    fwrite(STDERR, "REDIS_HOST must be a hostname or host:port address.\n");
    exit(1);
}
$server = Wikimedia\IPUtils::combineHostAndPort($address[0], $address[1] ?: 6379);

class ScheduledRedisJobChronService extends RedisJobChronService {
    private bool $hadErrors = false;

    public function __construct(string $server) {
        parent::__construct([
            'redis' => ['queues' => [$server], 'aggregators' => [$server]],
            'groups' => [],
            'limits' => ['claimTTL' => ['*' => 3600], 'attempts' => ['*' => 3]],
            'dispatcher' => 'unused',
        ]);
    }

    public function error($message) {
        $this->hadErrors = true;
        parent::error($message);
    }

    public function finish(): never {
        $this->notice('Scheduled housekeeping window completed.');
        exit($this->hadErrors ? 1 : 0);
    }
}

$service = new ScheduledRedisJobChronService($server);
pcntl_signal(SIGALRM, static function () use ($service) {
    $service->finish();
});
pcntl_alarm(45);
$service->main();
