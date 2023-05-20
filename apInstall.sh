nPack=$(sudo dpkg-query -l | grep apache2 | wc -l)
if [ $nPack -eq 0 ];then
        sudo apt update
        sudo apt full-upgrade -y
        sudo apt install apache2 -y
        #us=$(echo $USER)
        sudo cp -R /home/*/app /var/www/html

fi
