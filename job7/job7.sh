#!/bin/sh

sudo echo "export PATH='$PATH:/usr/sbin/'" >> ~/.bashrc
sudo source ~/.bashrc

#D'abord mettre à jour les paquets

apt-get update

#Ensuite installer FTP

apt-get install proftpd
apt-get install proftpd-mod-crypto

#Puis nous ajoutons les utilisateurs Merry et Pippin
echo "/bin/false" >> /etc/shells
adduser merry --shell /bin/false --home /home/merry
echo merry:kalimac | chpasswd
adduser pippin --shell /bin/false --home /home/pippin
echo pippin:secondbreakfast | chpasswd


echo "Include /etc/proftpd/conf.d/configftp" >> /etc/proftpd/proftpd.conf
#On créer la configuration anonyme
echo "<Anonymous ~ftp>
User ftp
Group nogroup
UserAlias anonymous ftp
DirFakeUser on ftp
DirFakeGroup on ftp
RequireValidShell off
MaxClients 10
<Directory *>
   <Limit WRITE>
    DenyAll
   </Limit>
  </Directory>
  </Anonymous>" >> /etc/proftpd/conf.d/configftp
  
#Enfin il reste à sécuriser en configurant TLS et SSL
#D'abord on créer le certificat et la clef
mkdir /etc/proftpd/ssl
openssl req -new -x509 -days 365 -nodes -out 
/etc/proftpd/ssl/proftpd-cert.pem -keyout /etc/proftpd/ssl/proftpd-key.pem

#Ensuite il faut activer SSL/TLS
echo "<IfModule mod_tls.c>
TLSEngine on
TLSLog /var/log/proftpd/tls.Log
TLSProtocol TLSv1 TLSv1.1 TLSv1.2 SSLv23
TLSRSACertificateFile /etc/proftpd/ssl/proftpd-cert.pem
TLSRSACertificateKeyFile /etc/proftpd/ssl/proftpd-key.pem
TLSVerifyClient off
TLSRequired on
</Ifmodule>
LoadModule mod_tls.c" >> /etc/proftpd/conf.d/configftp

#Enfin il faut redémarrer le serveur
systemctl restart proftpd
