# TigerGraph misc stuff

**About**
Here you will find a script to install TigerGraph workshop with TG-Developer latest version (3.0) and the ecosystem around it: MariaDB, Kafka, Zookeeper, Kafka Connect and Conda.

**Prerequisites** - 
1. [running docker](https://docs.docker.com/engine/install/)
2. [docker-compose](https://docs.docker.com/compose/install/)
3. Have available resources (some free disk and memory).

**How to install**
1. `wget https://bit.ly/tg_workshop -O deploy_ws.sh`
2. `chmod +x deploy_ws.sh`
3. `./deploy_ws.sh 1`

**Or as a single line**

`wget https://bit.ly/tg_workshop -O deploy_ws.sh && chmod +x deploy_ws.sh && ./deploy_ws.sh 1`

The number (1) after the .sh script will install fraud solution. We are working on additional solutions and will upload them online as soon as they are tested.

You will need Docker running on your instance.

Howto install Docker 
========================
# on AWS
```
sudo yum update -y

Amazon Linux 2:
sudo amazon-linux-extras install docker docker-compose

Amazon Linux:
sudo yum install docker docker-compose

Start the service:
sudo service docker start


Add ec2-user to the docker group (to be able to start sudo!):
sudo usermod -a -G docker ec2-user

Check if it's working:
docker info
```
# on Ubuntu
```
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
```
