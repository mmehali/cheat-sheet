ANNEXE 2 : Installation NGINX

Nous allons maintenant installer le serveur Nginx pour effectuer la terminaison SSL pour notre application Keycloak. Installez Nginx à l'aide du gestionnaire de packages YUM.
yum install nginx
Copiez les certificats SSL dans les chemins suivants sur le serveur:
•	Certificat: /etc/pki/tls/certs/
•	Clé privée: /etc/pki/tls/private/
Configurez Nginx pour le trafic proxy pour Keycloak. (Remplacez my.url.com par votre propre URL)
cat > /etc/nginx/conf.d/keycloak.conf <<EOF
upstream keycloak {
    # Use IP Hash for session persistence
    ip_hash;
  
    # List of Keycloak servers
    server 127.0.0.1:8080;
}
  
      
server {
    listen 80;
    server_name my.url.com;
 
    # Redirect all HTTP to HTTPS
    location / {   
      return 301 https://\$server_name\$request_uri;
    }
}
  
server {
    listen 443 ssl http2;
    server_name my.url.com;
 
    ssl_certificate /etc/pki/tls/certs/my-cert.cer;
    ssl_certificate_key /etc/pki/tls/private/my-key.key;
    ssl_session_cache shared:SSL:1m;
    ssl_prefer_server_ciphers on;
 
    location / {
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_pass http://keycloak;
    }
}
EOF
Activez et démarrez Nginx:
$ systemctl enable nginx
$ systemctl start nginx
Ouvrez les ports 80 et 443 dans votre pare-feu et vous avez terminé!
