# nzedb 0.6.9.0 to 0.7.0.0

This upgrade requires some manual steps to fix:
```
$ docker inspect slydetector/simply-nzedb | grep NZEDB_VERSION
$ mkdir data/configuration
$ mv data/config.php data/configuration/
$ mv data/ircscraper_settings.php data/configuration/
$ mv data/settings.php data/configuration/
$ touch data/configuration/install.lock
$ touch data/log/php_errors_web.log
$ chmod -R 777 data/configuration
```
