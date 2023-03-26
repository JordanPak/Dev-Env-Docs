server {
	listen 80;
	server_name wordpress.com;
	root /var/www/wordpress.com;

	include global/common.conf;
	include global/php8.conf;
	include global/wordpress.conf;
}
