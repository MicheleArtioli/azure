
program_name="mysql"

if command -v "$program_name" >/dev/null 2>&1; then
fi

sudo systemctl status mysql
if [ $? == 0 s];then
    sudo systemctl stop mysql        
fi
sudo apt purge mysql-server* -y
sudo rm -r /etc/mysql /var/lib/mysql -y
sudo apt autoremove -y
