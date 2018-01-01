#!/bin/bash
#@ User Data to spin up docker container & start WP Server

Prepair_Wordpress()
{
	AWS_REGION=`curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region`
	echo $AWS_REGION >/tmp/aws_region
        sudo apt-get install apache2 -y
	cd /opt 
	sudo wget -c http://wordpress.org/latest.tar.gz
	sudo tar -xvzf latest.tar.gz
	cd /opt/wordpress
	sudo mv wp-config-sample.php wp-config.php 
	sudo sed -i 's/database_name_here/wordpress_db/g' wp-config.php
	sudo sed -i 's/username_here/wpuser/g' wp-config.php
	sudo sed -i 's/password_here/wpuser@/g' wp-config.php
	sudo cp -R /opt/wordpress/* /var/www/html
	sudo chown -R www-data:www-data /var/www/html
}
mount_docker_volume()
{
	echo "Mounting file system to wordpress Drive"
	sudo mkfs -t ext4 /dev/xvdf
	sudo mkdir /docker
	sudo e2label /dev/xvdf docker
	echo 'LABEL=docker  /docker	ext4    defaults 	0   0' |sudo tee --append /etc/fstab
	sudo mount -a
	sudo df -kh 
}
start_container()
{
	sudo docker pull mariadb
	sudo docker run -e MYSQL_ROOT_PASSWORD=root123 -e MYSQL_USER=wpuser -e MYSQL_PASSWORD=wpuser@ -e MYSQL_DATABASE=wordpress_db -v /docker/database:/var/lib/mysql --name wordpressdb -d mariadb
        export MYSQL_IP=$(docker inspect wordpressdb|jq -r .[].NetworkSettings.Networks.bridge.IPAddress)
	sudo sed -i "s/localhost/$MYSQL_IP/g" /var/www/html/wp-config.php
}
restart_wordpress()
{     
	sudo rm -rf /var/www/html/index.html 
	sudo systemctl restart apache2
	sudo systemctl enable apache2
}
Prepair_Wordpress
mount_docker_volume
start_container
restart_wordpress