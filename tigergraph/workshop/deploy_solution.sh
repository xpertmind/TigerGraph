#!/bin/bash

# check parameters
if [ $# -lt 1 ]; then
  echo "Error: please use the SOLUTION NUMBER argument to start the deployment"
  echo "$0 1 -> Fraud"
  echo "$0 2 -> Synthea-Medgraph"

  exit 2
elif [ $# -gt 1 ]; then
  echo 1>&2 "$0: too many arguments"
  exit 2
fi

# start docker-compose as deamon
VOL_DIR="volume/"

if [ ! -d "scripts" ]; then
  mkdir "scripts"
fi

# Fraud solution
if [ "$1" == "1" ]; then
  # check if all the folders are created
  if [ ! -d $VOL_DIR ]; then
  echo "--> creating needed folders ..."
    mkdir $VOL_DIR
    mkdir $VOL_DIR/k_connect
    mkdir $VOL_DIR/kafka
    mkdir $VOL_DIR/kafka/data
    mkdir $VOL_DIR/MariaDB
    mkdir $VOL_DIR/MariaDB/data
    mkdir $VOL_DIR/MariaDB/logs
    mkdir $VOL_DIR/MariaDB/conf.d
    mkdir $VOL_DIR/TigerGraph
    mkdir $VOL_DIR/TigerGraph/scripts
    mkdir $VOL_DIR/TigerGraph/data
    mkdir $VOL_DIR/zookeeper
    mkdir $VOL_DIR/zookeeper/data
    mkdir $VOL_DIR/zookeeper/txns
  fi
  # to log into a container
  # docker exec -t -i tg_dev3 /bin/bash

  chmod -R 777 volume/
  if [ ! -f docker-compose.yaml ]; then
      # download docker compose
      wget https://raw.githubusercontent.com/xpertmind/TigerGraph/master/tigergraph/workshop/docker-compose.yaml
      #sed -i '' 's/10.16.33/10.116.133/' docker-compose.yaml
  fi
  if [ ! -d "scripts/solutions" ]; then
    mkdir "scripts/solutions"
  fi
      SOL_DIR="scripts/solutions/fraud/"
      DEPLOY_FILE=$SOL_DIR"deploy.sh"
      if [ ! -f "$DEPLOY_FILE" ]; then
          echo "--> downloading anti-fraud workshop data"
          wget https://github.com/xpertmind/TigerGraph/raw/master/tigergraph/workshop/fraud.zip
          unzip fraud.zip
      fi
      echo "--> starting to deploy containers:"
      docker-compose up -d
      source $SOL_DIR/deploy.sh

# Starting Synthea-Medgraph deployment
elif [ "$1" == "2" ]; then
  if [ ! -f docker-compose.yaml ]; then
      # download docker compose
      wget https://raw.githubusercontent.com/xpertmind/TigerGraph/master/tigergraph/synthea-medgraph/docker-compose.yaml
  fi
  SOL_DIR="scripts/synthea-medgraph/"
  if [ ! -d $SOL_DIR ]; then
    mkdir $SOL_DIR
  fi
  DOCKER="syntheatg3"
  DEPLOY_FILE=$SOL_DIR"deploy.sh"
  if [ ! -f "$DEPLOY_FILE" ]; then
      echo "--> downloading synthea-medgraph solution scripts & data"
      wget https://github.com/xpertmind/TigerGraph/raw/master/tigergraph/synthea-medgraph/synthea-data.zip
      unzip synthea-data.zip
  fi
  echo "--> starting deployment"
  docker-compose up -d
  source $SOL_DIR/deploy.sh
fi

docker-compose ps

echo "####"
echo "To stop this workshop:        docker-compose stop"
echo "To terminate this workshop:   docker-compose down"
echo "####"

# load the data depending on solution
# 1 Fraud
# 2 Covid-19
# 3 tbd
