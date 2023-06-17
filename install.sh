#!/bin/bash

# Mettre à jour les paquets disponibles
sudo apt update

# Installer les dépendances Python
sudo apt install python3-pip python3-dev build-essential libssl-dev libffi-dev python3-setuptools -y

# Installer Python Virtual Environment
sudo apt install python3-venv -y

# Créer le répertoire pour le projet
mkdir ~/mymasterproject
cd mymasterproject/

# Créer un environnement virtuel
python3 -m venv mymasterprojectenv

# Activer l'environnement virtuel
source mymasterprojectenv/bin/activate

# Installer les paquets nécessaires
pip install wheel
pip install gunicorn flask

# Installer Nginx et mysql
sudo apt install mysql-server postfix supervisor nginx git -y

# Installer docker
sudo apt-get update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-cache policy docker-ce
sudo apt install docker-ce -y

# Installation de Kubernetes
curl -sfL https://get.k3s.io | sh -

# Terminé !
echo "L'installation est terminée."
