program_name="mysql"

if command -v "$program_name" >/dev/null 2>&1; then
    exit 1
else
    sudo apt apdate -y
    sudo apt upgrade -y
    sudo apt install mysql-server -y
    sudo systemctl status mysql
    if [ $? > 0 ];then
        sudo systemctl start mysql
    fi
    sudo sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
    sudo ufw allow 3306/tcp
    sudo systemctl restart mysql.service
fi

