nPack=$(sudo dpkg-query -l | grep apache2 | wc -l)
if [ $nPack != 0 ]; then
    sudo service apache2 stop
    sudo apt purge apache2 apache2-utils apache2-bin apache2.2-common -y
    sudo apt remove --force -y
    sudo rm -rf /etc/apache2
fi
