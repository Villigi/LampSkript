#!/bin/bash

# Update Paketliste
apt update && apt upgrade -y

# Installation von Apache2, MariaDB und PHP
apt install -y apache2 mariadb-server php php-mysql libapache2-mod-php php-cli php-mbstring php-xml unzip

# Sicherstellen, dass Apache und MariaDB laufen und beim Booten starten
systemctl enable --now apache2
systemctl enable --now mariadb

# MariaDB-Sicherheitskonfiguration (ohne interaktive Eingabe)
mysql -e "UPDATE mysql.user SET Password = PASSWORD('root') WHERE User = 'root';"
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';"
mysql -e "FLUSH PRIVILEGES;"

# Erstellen des MariaDB-Nutzers
mysql -u root -proot -e "CREATE USER 'Admin'@'localhost' IDENTIFIED BY 'Admin';"
mysql -u root -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'Admin'@'localhost' WITH GRANT OPTION;"
mysql -u root -proot -e "FLUSH PRIVILEGES;"

# phpMyAdmin herunterladen und installieren
apt install -y phpmyadmin
ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin

# Apache neu starten
systemctl restart apache2

echo "Installation abgeschlossen! phpMyAdmin ist unter http://<SERVER-IP>/phpmyadmin erreichbar."
