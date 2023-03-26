# WSL2 Ubuntu LEMP Setup

LEMP environment for local web application development (+WordPress)      on Windows. 

## General

1. Install latest Ubuntu LTS from [Microsoft Store](https://apps.microsoft.com/store/apps)

## Nginx, MySQL, PHP, and Firewall (??)

1. Follow [Digital Ocean's LEMP guide](https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-on-ubuntu-22-04) for installing Nginx, MySQL, and PHP.

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
