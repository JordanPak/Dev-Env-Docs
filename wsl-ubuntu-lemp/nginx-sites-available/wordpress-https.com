server {
	server_name wordpress.com;
	root /var/www/wordpress.com;

	include global/ssl.conf;
	include global/common.conf;
	include global/php8.conf;
	include global/wordpress.conf;
}

server {
	listen 80;
	server_name wordpress.com;
	return 301 https://$host$request_uri;
}
