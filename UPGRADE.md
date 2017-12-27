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

# nzedb 0.8.1.0 to 0.8.2.1

Add new maintenance settings to the bottom of data/configuration/settings.php
```
////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// Maintenance Mode Settings //////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Should the site be in maintenance mode.
 * If enabled, it will output the selected HTML file added below to front-end pages as well as
 * outputting a properly formatted API error response with the error text "Maintenance Mode" and
 * status code 503.
 * This will prevent nZEDb from making any MySQL/Sphinx/Cache calls so it's good to use this if you
 * need to stop/restart those services.
 *
 * @note If your site uses some form of webserver-level caching, the cache may need to be cleared
 *      when coming out of maintenance mode. Otherwise you'll have to wait until it expires to see
 *         your proper site again.
 * @default false
 */
define('MAINTENANCE_MODE_ENABLED', false);

/**
 * The fully qualified absolute path to the maintenance mode HTML file.
 * This should be a fully complete HTML file and NOT a smarty template. The idea of a maintenance
 * file is it should be static HTML with no dependencies on other systems.
 * That way it can safely be displayed without the database running or any other services (except
 * PHP and the webserver of course).
 *
 * @note On my site I ripped the rendered HTML content of my home page and swapped out the center
 *      container for a maintenance message. This is a good process. Be sure to remove all
 *        references to user data. Links to other site pages can remain intact.
 * @default ''
 */
define('MAINTENANCE_MODE_HTML_PATH', '');

/**
 * What IP addresses should be excluded from maintenance mode.
 *
 * Useful if you want to allow admins to access the site while everyone else sees the maintenance
 * message.
 *
 * @note Keep in mind, if your site uses ipv6 you may need to enter your ipv6 address here as well.
 * @default []
 */
define('MAINTENANCE_MODE_IP_EXCEPTIONS', []);
```
