# VS Code PHPCS Config

## Install PHPCS and WordPress Standards with Composer
1. Require [WP Coding Standards](https://packagist.org/packages/wp-coding-standards/wpcs): `composer require --dev wp-coding-standards/wpcs`
1. Require [PHP_CodeSniffer Standards Composer Installer Plugin](https://packagist.org/packages/dealerdirect/phpcodesniffer-composer-installer): `composer require --dev dealerdirect/phpcodesniffer-composer-installer`. This is required because the one that comes with WPCS doesn't work 🤷‍♀️.
1. Clear caches and reinstall everything:
   1. `rm -rf vendor`
   1. `rm composer.lock`
   1. `composer clear-cache`
   1. `composer install` (output should contain "_The installed coding standards are..._" with `WordPress`)

## Connect VS Code
