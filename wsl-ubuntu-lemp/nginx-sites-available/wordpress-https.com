server {
	server_name wordpress.com www.wordpress.com;
	root /var/www/wordpress.com;

	include global/ssl.conf;
	include global/common.conf;
	include global/php8.conf;
	include global/wordpress.conf;
}

server {
	if ($host = www.wordpress.com) {
		return 301 https://$host$request_uri;
	} # managed by Certbot

	if ($host = wordpress.com) {
		return 301 https://$host$request_uri;
	} # managed by Certbot

	server_name wordpress.com www.wordpress.com;
	listen 80;
	return 404; # managed by Certbot
}
