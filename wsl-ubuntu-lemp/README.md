# WSL2 Ubuntu LEMP Setup

LEMP environment for local web application development (+WordPress)      on Windows. 

## General

1. Install latest Ubuntu LTS from [Microsoft Store](https://apps.microsoft.com/store/apps)
1. Install [Zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH) and [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh/wiki#welcome-to-oh-my-zsh)
1. Install `zip` and `unzip`: `sudo apt install zip unzip` (these are dependencies for the WP-CLI composer install)

## Nginx, MySQL, PHP, and Firewall (??)

1. Follow [Digital Ocean's LEMP guide](https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-on-ubuntu-22-04) for installing Nginx, MySQL, and PHP.

### PHP Adjustments

1. **(DON'T DO THIS)** Open the PHP FPM config for each version (`/etc/php/X.X/pool.d/www.conf`), comment out the `listen` set to the socket, and add `listen = 127.0.0.1:9000` instead.
1. Open the PHP FPM config for each version (`/etc/php/X.X/pool.d/www.conf`) and switch the `user` and `group` to your username (helps with WordPress perms)
1. Install misc extensions: `sudo apt install php-curl php-xml php-imagick php-zip php-gd php-intl php-pecl php-dev`
1. Restart PHP: `sudo service phpX.X-fpm restart && sudo service phpX.X-fpm reload`

### Composer

1. Create a `.composer` directory in the user folder (`mkdir ~/.composer && cd ~/.composer`)
1. Follow [the Composer install instructions](https://getcomposer.org/download/) (with `php -r ...`)
1. Move the `composer.phar` file to `/usr/local/bin`, as noted in Composer's docs (`sudo mv composer.phar /usr/local/bin/composer`)
1. Clear the *contents* of `~/.composer` (`cd ~/.composer && rm -rf *`)
1. Init a "global" Composer project for the user from `~/.composer`: `composer init`, filling out the prompts:
   1. "Minimum Stability" isn't needed
   1. Type can be `project`
   1. License isn't needed
   1. Dependencies don't need to be defined
   1. Don't enable autoload mapping
1. Remove the `.htaccess` if one was created. It isn't needed.
1. Add Composer's `vendor` directory to the user `PATH` by adding `export PATH="$HOME/.composer/vendor/bin:$PATH"` to the top of `~/.zshrc`. Run `source ~/.zshrc` or log out and log in again to use the composer packages.

### Nginx Adjustments

1. Configure `/etc/nginx/nginx.conf`
   1. Comment out `user www-data;` at the top and add `user %your_sudo_user%;`
   1. Enable `server_names_hash_bucket_size 64;`
   1. Configure `gzip`
      1. Enable all of the `gzip_` settings
      1. add `gzip_min_length 256;` before `gzip_types`
      1. Set `gzip-types` to
      ```
              gzip_types
                      application/atom+xml
                      application/geo+json
                      application/javascript
                      application/x-javascript
                      application/json
                      application/ld+json
                      application/manifest+json
                      application/rdf+xml
                      application/rss+xml
                      application/xhtml+xml
                      application/xml
                      font/eot
                      font/otf
                      font/ttf
                      image/svg+xml
                      text/css
                      text/javascript
                      text/plain
                      text/xml;
      ```
   1. Add the following settings to a new section below `# Virtual Host Configs`
   ```
   ##
   # ADDED BY %YOUR NAME%
   ##
   fastcgi_buffering off;
   #fastcgi_buffers 16 16k; # in case a heavier site needs it later
   #fastcgi_buffer_size 32k; # in case a heavier site needs it later
   index index.php; # look for PHP by default
   client_max_body_size 24M; # support heavier documents/requests
   ```
   1. Save `nginx.conf`
1. Add the files in this README directory's `./nginx-global` to a new `/etc/nginx/global` (`common`, `phpX`, `wordpress` `conf` files). **Note:** some of the minor PHP versions may need to be updated!
1. To add a new WordPress vhost/server block, start with the `./nginx-sites-available/example-http.com`. Once a *Let's Encrypt* certificate is provisioned for the site, the file may need to be altered to look more like `./nginx-sites-available/example-https.com`.
1. Restart nginx: `sudo service restart nginx`

### WP-CLI

1. Navigate to "user global" composer: `cd ~/.composer`
1. Install framework + default commands
   1. `composer require wp-cli/wp-cli`
   1. `composer require wp-cli/wp-cli-bundle`
1. Install [Oh My Zsh bash completions](https://make.wordpress.org/cli/handbook/guides/installing/#oh-my-zsh)

### Certbot

Until Windows 11 is installed or `systemd` becomes compatible with WSL on Windows 10, Certbot's recommended `snap` install will not work. Just use `sudo apt install certbot` for now.

The following can be used to provision a wildcard certificate:
```
sudo certbot certonly --agree-tos --email YOUR-ACTUAL-EMAIL@EMAIL.EMAIL --manual --preferred-challenges=dns -d "*.local.yourdomain.com" --server https://acme-v02.api.letsencrypt.org/directory
```

### Memcached

1. Install Memcached and PHP-specific package(s): `sudo apt install memcached php8.1-memcache`
1. Install `zlib`: `sudo apt install zlib1g zlib1g-dev`
1. Install `memcached` PHP extension with PECL: `sudo pecl install memcache`
1. Add `extension=memcache.so` to `php.ini` (for each PHP version)
1. Install the [Memcached Object Cache plugin](https://wordpress.org/plugins/memcached/) per instructions
1. Use [Query Monitor plugin](https://wordpress.org/plugins/query-monitor/) to verify object caching

### Xdebug

1. Follow [Xdebug's `pecl` installation documentation](https://xdebug.org/docs/install#pecl)
1. Make sure `zend_extension=/usr/lib/php/20210902/xdebug.so` is in each `php.ini`
1. Add the following extension configuration to `php.ini`
   ```
   [xdebug]
   xdebug.mode=debug
   xdebug.start_with_request=yes
   ```
3. Restart Nginx and PHP

NOTE: Additional PHP versions' package will probably have to be built manually:
1. Switch PHP version to the one Xdebug is being installed for: `sudo update-alternatives --config php`
1. Follow [Xdebug's instructions on compiling from source](https://xdebug.org/docs/install#compile) after downloading from GitHub releases
1. You may need to reinstall the first Xdebug with PECL again 

## Helper Script

1. Download [`start-web-services.sh`](https://raw.githubusercontent.com/JordanPak/Dev-Env-Docs/main/wsl-ubuntu-lemp/start-web-services.sh) from this README's repo directory to the user folder:
   ```
   cd ~ && curl -O https://raw.githubusercontent.com/JordanPak/Dev-Env-Docs/main/wsl-ubuntu-lemp/start-web-services.sh
   ```
1. Make the script executable: `chmod +x ~/start-web-services.sh`
1. Run `cd ~ && ./start-web-services.sh` after starting the machine and shelling in


## Node Version Manager (NVM)

Install per [NVM's README](https://github.com/nvm-sh/nvm#install--update-script)
