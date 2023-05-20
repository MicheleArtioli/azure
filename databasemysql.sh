sudo mysql -u root -e "CREATE USER 'ssh'@'%' IDENTIFIED BY 'password';"
sudo mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'ssh'@'%';"
sudo mysql -u root -e "FLUSH PRIVILEGES;"

sudo mysql -u root -e "CREATE DATABASE db_TPSProject CHARACTER SET = 'utf8' COLLATE = 'utf8_general_ci';"

sudo mysql -u root -e "CREATE TABLE db_TPSProject.tbl_users (user_id INT UNSIGNED NOT NULL AUTO_INCREMENT,user_name VARCHAR(100), user_email VARCHAR(100), user_password VARCHAR(100), PRIMARY KEY (user_id));"

sudo mysql -u root -e "CREATE TABLE db_TPSProject.tbl_temp (temp_id INT UNSIGNED NOT NULL AUTO_INCREMENT,temp_value FLOAT DEFAULT 0.00,data_measure VARCHAR(100),time_measure VARCHAR(100),PRIMARY KEY (temp_id));"

sudo mysql -u root -e "CREATE TABLE db_TPSProject.tbl_press (press_id INT UNSIGNED NOT NULL AUTO_INCREMENT,press_value FLOAT DEFAULT 0.00,data_measure VARCHAR(100),time_measure VARCHAR(100),PRIMARY KEY (press_id));" 
