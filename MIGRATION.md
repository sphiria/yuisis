# 

# 1. fix mediawiki.ipblocks
```DELETE FROM mediawiki.ipblocks
	WHERE ipb_id=541;
```

# 2. run php update.php (ETA 10 hours)
```php maintenance/update.php```



# fix side menu