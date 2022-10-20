#!/bin/sh

sudo apt-add-repository ppa:cubic-wizard/release
#c'est un truc pour custo son linux 

sudo apt update 
sudo apt install -y proftp filezilla 
#-y insalation de bas du logiciel  suivi des logiciel
sudo apt upgrade && sudo apt dist-upgrade
#mise a jour 
sudo dpkg -i ~/Téléchargements/*.deb
#instal les paquet dans le dossier nomer
sudo apt --fix-broken install

