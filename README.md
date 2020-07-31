# TigerGraph misc stuff

Here you will find a script to install TigerGraph workshop with TG-Developer latest version (3.0) and the ecco system around it: MariaDB, Kafka, Zookeeper, Kafka Connect and Conda.\
\
Prerequisites - running docker and docker-compose, some free disk and memory.\
\
How to install:\
wget https://bit.ly/tg_workshop -O deploy_ws.sh\
chmod +x deploy_ws.sh\
./deploy_ws.sh 1\
\
Or as a single line:\
wget https://bit.ly/tg_workshop -O deploy_ws.sh && chmod +x deploy_ws.sh && ./deploy_ws.sh 1\
\
The number (1) after the .sh script will install fraud solution. We are working on additional solutions and will upload them online as soon as they are tested.
