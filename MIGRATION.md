# MIGRATION STEPS

# 1. clear all pending jobs

# 2. backup

# 3. restore db

# 4. fix mediawiki.ipblocks (see if we can do this on live db to save a step)
```
echo "DELETE FROM mediawiki.ipblocks WHERE ipb_id=541;" | mysql -h 127.0.0.1 -uroot -p 
```

# 5. cleanupUsersWithNoId on 1.35.14 - 1 minute
```php83 maintenance/cleanupUsersWithNoId.php --prefix '*'
```

# 6. update on 1.35.14 - 17s
```php83 maintenance/update.php
```

# 7. update on 1.41.0 -  1 h 6 min 41 s.
```php83 maintenance/run.php update
```


?
# 5. uninstall flow
 https://wikitech.wikimedia.org/wiki/Flow
```SELECT CONCAT('Topic:', page_title) AS page_title FROM page WHERE page_namespace=2600 into outfile '/tmp/pagelist.csv';

and run 

php83 maintenance/run.php deleteBatch --wiki=mediawiki -u='Gyaru' -r='Uninstalling Flow' /tmp/pagelist.csv

```


maintenance/cleanupUsersWithNoId.php to fix this situation