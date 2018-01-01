#!/bin/bash
#@Sole purpose to boot_strap wordpress Server with dependacies!!
#@This can be further expanded using Packer based requirements (packer.io).


aws_cloud_watch_agent_installer()
{
	sudo mkdir -p  /scripts/ubuntu
	sudo chmod a+w /scripts/ubuntu
	sudo apt-get update
	sudo apt-get -y install curl python software-properties-common xz-utils bzip2 gnupg wget graphviz
	sudo wget -O /scripts/ubuntu/awslogs-agent-setup.py http://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py
	sudo chmod 775 /scripts/ubuntu/awslogs-agent-setup.py
	sudo mkdir -p /var/awslogs/etc/
	echo "Finished Installing AWS cloudwatch agent Installer"
}
Install_Docker()
{
	sudo apt-get update
	sudo apt-get install \
	    linux-image-extra-$(uname -r) \
	    linux-image-extra-virtual
	sudo apt-get install \
	    apt-transport-https \
	    ca-certificates \
	    curl \
	    software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo apt-key fingerprint 0EBFCD88
	sudo add-apt-repository \
	   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	   $(lsb_release -cs) \
	   stable"
	sudo apt-get update
	sudo apt-get install -y docker-ce
	sudo systemctl daemon-reload
	sudo service docker restart
	echo "Finishhed Installing Docker Deamon"

}
Start_monit()
{
  	sudo apt-get install monit
	echo "* Putting the following services under Monit control *"
	for SERVICE in $(ls /tmp/monit/); do
		if [ "${SERVICE}" != "monit_http" ]; then
		    echo " - ${SERVICE}"
		    sudo mv -f /tmp/monit/${SERVICE} /etc/monit/conf.d/
		else
			sudo mv -f /tmp/monit/${SERVICE} /etc/monit/conf.d/
		fi
	done
	
echo "Cleaning up Temp Directories"
sudo rm -rf /tmp/*
sudo rm -rf ~/tmp

}
Install_python_php()
{
	sudo apt-get install -y python3 python3-pip php7.0 php7.0-mysql libapache2-mod-php7.0 php7.0-cli php7.0-cgi php7.0-gd jq unzip -y
	sudo pip3 install --upgrade awscli
	sudo pip3 install requests
	sudo pip3 install google-api-python-client
	sudo pip3 install httplib2
	sudo pip3 install oauth2client
	sudo pip3 install oauthlib
	sudo pip3 install urllib3
	sudo pip3 install boto3
}

Install_Docker
Start_monit
Install_python_php
