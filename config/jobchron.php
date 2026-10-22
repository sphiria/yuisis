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
$redisHost = $address[0];
$redisPort = (int)($address[1] ?: 6379);
$server = Wikimedia\IPUtils::combineHostAndPort($redisHost, $redisPort);
$password = getenv('REDIS_PASSWORD');
$username = trim((string)getenv('REDIS_USERNAME'));
$credentials = null;
if (is_string($password) && $password !== '') {
    $credentials = $username === '' ? $password : [$username, $password];
}

function waitForRedis(
    string $host,
    int $port,
    string|array|null $credentials,
    int $timeoutSeconds = 15
): void {
    $deadline = hrtime(true) + ($timeoutSeconds * 1_000_000_000);
    $lastError = 'connection failed';

    do {
        $redis = new Redis();
        try {
            if ($redis->connect($host, $port, 1.0) === false) {
                $lastError = 'connect returned false';
            } elseif ($credentials !== null && $redis->auth($credentials) === false) {
                $lastError = 'authentication failed';
            } elseif ($redis->ping() !== false) {
                $redis->close();
                return;
            } else {
                $lastError = 'ping returned false';
            }
        } catch (RedisException $exception) {
            $lastError = $exception->getMessage();
        }

        unset($redis);
        usleep(250_000);
    } while (hrtime(true) < $deadline);

    fwrite(
        STDERR,
        "Redis did not become reachable within {$timeoutSeconds} seconds: {$lastError}\n"
    );
    exit(1);
}

waitForRedis($redisHost, $redisPort, $credentials);

class ScheduledRedisJobChronService extends RedisJobChronService {
    private bool $hadErrors = false;

    public function __construct(string $server, string|array|null $credentials) {
        $redis = ['queues' => [$server], 'aggregators' => [$server]];
        if ($credentials !== null) {
            $redis['password'] = $credentials;
        }
        parent::__construct([
            'redis' => $redis,
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

$service = new ScheduledRedisJobChronService($server, $credentials);
pcntl_signal(SIGALRM, static function () use ($service) {
    $service->finish();
});
pcntl_alarm(45);
$service->main();
