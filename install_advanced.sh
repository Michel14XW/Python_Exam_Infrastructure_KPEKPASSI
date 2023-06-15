#!/bin/bash

# Étape 1 - Installation des composants depuis les référentiels Ubuntu
sudo apt update
sudo apt install -y python3-pip python3-dev build-essential libssl-dev libffi-dev python3-setuptools

# Étape 2 - Création d'un environnement virtuel Python
sudo apt install -y python3-venv
mkdir ~/mymasterproject
cd ~/mymasterproject
python3 -m venv mymasterprojectenv
source mymasterprojectenv/bin/activate

# Étape 3 - Configuration d'une application Flask
pip install wheel
pip install gunicorn flask

# Création de l'application Flask
cat <<EOF > ~/mymasterproject/mymasterproject.py
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "<h1 style='color:blue'>Hello There!</h1>"

if __name__ == "__main__":
    app.run(host='0.0.0.0')
EOF

# Autorisation de l'accès au port 5000
sudo ufw allow 5000

# Exécution de l'application Flask
python ~/mymasterproject/mymasterproject.py &

# Création du point d'entrée WSGI
cat <<EOF > ~/mymasterproject/wsgi.py
from mymasterproject import app

if __name__ == "__main__":
    app.run()
EOF

# Étape 4 - Configuration de Gunicorn et du service systemd
cat <<EOF | sudo tee /etc/systemd/system/mymasterproject.service > /dev/null
[Unit]
Description=Gunicorn instance to serve mymasterproject
After=network.target

[Service]
User=vagrant
Group=www-data
WorkingDirectory=/home/vagrant/mymasterproject
Environment="PATH=/home/vagrant/mymasterproject/mymasterprojectenv/bin"
ExecStart=/home/vagrant/mymasterproject/mymasterprojectenv/bin/gunicorn --workers 3 --bind unix:mymasterproject.sock -m 007 wsgi:app

[Install]
WantedBy=multi-user.target
EOF

# Rechargement de systemd
sudo systemctl daemon-reload

# Démarrage et activation du service mymasterproject
sudo systemctl start mymasterproject
sudo systemctl enable mymasterproject

# Vérification du statut du service mymasterproject
sudo systemctl status mymasterproject

# Désactivation de l'environnement virtuel
deactivate

# Étape 5 - Configuration de Nginx
sudo apt install -y nginx

# Création du fichier de configuration pour Nginx
sudo tee /etc/nginx/sites-available/mymasterproject > /dev/null <<EOF
server {
    listen 80;
    server_name 192.168.148.10;

    location / {
        include proxy_params;
        proxy_pass http://unix:/home/vagrant/mymasterproject/mymasterproject.sock;
    }
}
EOF

# Activation du site Nginx
sudo ln -s /etc/nginx/sites-available/mymasterproject /etc/nginx/sites-enabled/
sudo systemctl restart nginx
