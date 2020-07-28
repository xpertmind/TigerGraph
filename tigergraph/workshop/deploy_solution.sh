#!/bin/bash

# check parameters
if [ $# -lt 1 ]; then
  echo "Error: please use the SOLUTION NUMBER argument to start the deployment"
  echo "$0 1 -> Fraud"
  echo "$0 2 -> Covid-19"

  exit 2
elif [ $# -gt 1 ]; then
  echo 1>&2 "$0: too many arguments"
  exit 2
fi

# start docker-compose as deamon
VOL_DIR="volume/"

# check if all the folders are created
if [ ! -d "volume" ]; then
  mkdir "volume"
  mkdir "volume/k_connect"
  mkdir "volume/kafka"
  mkdir "volume/kafka/data"
  mkdir "volume/MariaDB"
  mkdir "volume/MariaDB/data"
  mkdir "volume/MariaDB/logs"
  mkdir "volume/MariaDB/conf.d"
  mkdir "volume/TigerGraph"
  mkdir "volume/TigerGraph/scripts"
  mkdir "volume/TigerGraph/data"
  mkdir "volume/zookeeper"
  mkdir "volume/zookeeper/data"
  mkdir "volume/zookeeper/txns"
fi
if [ ! -d "scripts" ]; then
  mkdir "scripts"
  mkdir "scripts/solutions"
fi

if [ ! -f docker-compose.yaml ]; then
    # download docker compose
    wget https://raw.githubusercontent.com/xpertmind/TigerGraph/master/tigergraph/workshop/docker-compose.yaml
    sed -i '' 's/10.16.33/10.116.133/' docker-compose.yaml
fi

if [ "$1" == "1" ]; then
      SOL_DIR="scripts/solutions/fraud/"
      DEPLOY_FILE=$SOL_DIR"deploy.sh"
      if [ ! -f "$DEPLOY_FILE" ]; then
        wget https://github.com/xpertmind/TigerGraph/raw/master/tigergraph/workshop/fraud.zip
        unzip fraud.zip
      fi
      docker-compose up -d
      source $SOL_DIR/deploy.sh

elif [ "$1" == "2" ]; then
  echo "solution not implemented yet"
fi

docker-compose ps
echo "Done!"
# load the data depending on solution
# 1 Fraud
# 2 Covid-19
# 3 tbd
