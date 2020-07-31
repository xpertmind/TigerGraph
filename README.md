# TigerGraph misc stuff

Here you will find a script to install TigerGraph workshop with TG-Developer latest version (3.0) and the ecco system around it: MariaDB, Kafka, Zookeeper, Kafka Connect and Conda.\
\
Prerequisites - running docker and docker-compose, some free disk and memory.\
\
How to install:\
wget https://bit.ly/tg_workshop -O deploy_ws.sh\
chmod +x deploy_ws.sh\
./deploy_ws.sh 1
\
Or as a single line:\
wget https://bit.ly/tg_workshop -O deploy_ws.sh && chmod +x deploy_ws.sh && ./deploy_ws.sh 1\
\
The number (1) after the .sh script will install fraud solution. We are working on additional solutions and will upload them online as soon as they are tested.

You will need Docker running on your instance.

Howto install Docker 
========================
# on AWS

sudo yum update -y

Amazon Linux 2:
sudo amazon-linux-extras install docker

Amazon Linux:
sudo yum install docker

Start the service:
sudo service docker start


Add ec2-user to the docker group (to be able to start sudo!):
sudo usermod -a -G docker ec2-user

Check if it's working:
docker info

# on Ubuntu

sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
 
(add dockers official key)

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

(Verify that you now have the key with the fingerprint
9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
, by searching for the
last 8 characters of the fingerprint.)

sudo apt-key fingerprint 0EBFCD88

(add stable repository)
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs)  stable"

(for mint tricia)
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic  stable"

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

(check if it's working)
sudo docker run hello-world

(add local user to the docker group!)
sudo usermod -aG docker bruno

(test withoud sudo)
docker info

(log out and log in!)
