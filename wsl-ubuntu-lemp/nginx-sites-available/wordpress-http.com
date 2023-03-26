server {
	listen 80;
	server_name wordpress.com www.wordpress.com;
	root /var/www/jordanpak.com;

	include global/common.conf;
	include global/php8.conf;
	include global/wordpress.conf;
}
