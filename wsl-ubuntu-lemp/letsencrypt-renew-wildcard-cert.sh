# @see https://dev.to/nabbisen/let-s-encrypt-renew-wildcard-certificate-manually-with-certbot-1jp

# Delete existing wildcard certificate.
sudo certbot delete

# Create new certificate.
sudo certbot certonly --manual --manual-public-ip-logging-ok --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory -d "*.local.jordanpak.com" 

# Restart nginx
sudo service nginx restart
sudo service nginx reload
