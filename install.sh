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



# Terminé !
echo "L'installation est terminée."
