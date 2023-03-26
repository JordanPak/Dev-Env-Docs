server {
	server_name wordpress.com www.wordpress.com;
	root /var/www/wordpress.com;

	include global/common.conf;
	include global/php8.conf;
	include global/wordpress.conf;

	listen 443 ssl default_server; # managed by Certbot
	ssl_certificate /etc/letsencrypt/live/wordpress.com/fullchain.pem; # managed by Certbot
	ssl_certificate_key /etc/letsencrypt/live/wordpress.com/privkey.pem; # managed by Certbot
	include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
	ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
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
