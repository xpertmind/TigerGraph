#!/bin/bash

# check some stuff before starting
if [[ ! $(which docker) && ! $(docker --version) ]]; then
  echo "This workshop depends on Docker and docker-compose. Please install them on your system."
  echo "Howto install Docker: https://docs.docker.com/engine/install"
  echo ".... and for compose: https://docs.docker.com/compose/install"
  exit 2
fi

if [[ ! $(which docker-compose) && ! $(docker-compose --version) ]]; then
    echo "This workshop depends on Docker and docker-compose. Please install them on your system."
    echo "Howto install Docker: https://docs.docker.com/engine/install"
    echo ".... and for compose: https://docs.docker.com/compose/install"
    exit 2
fi


if [ $# -lt 1 ]; then
  echo "$0 1 -> Fraud"
  echo "$0 2 -> Synthea-Medgraph"
  get_tgport_number()
  read -p 'Enter solution number: ' solnumber
  if [ -z "$solnumber" ]
	then
    echo "Error: please use a SOLUTION NUMBER argument to start the deployment"
	  exit 2
	fi

  exit 2
elif [ $# -gt 1 ]; then
  echo 1>&2 "$0: too many arguments"
  exit 2
fi

# define some default variables
VOL_DIR="volume/"
TG_GUI_PORT=14240
TG_API_PORT=9000
TG_SSH_PORT=22

# functions for dynamic setup
function get_tggui_port() {
#! /bin/bash
#Prompt user to insert inputs (one at a time)
read -p 'Enter TigerGraph GUI port [14240]: ' tg_gui_port

#Firstly Validate if any input field is left blank
#If an input field is left blank, display appropriate message and stop execution of script
if [ -z "$tg_gui_port" ]
then
	$tg_gui_port = $1
fi

#Now Validate if the user input is a number (Integer or Float)
#If an input field not a number, display appropriate message and stop execution of script
if ! [[ "$tg_gui_port" =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]
    then
        echo "Please enter a number between 80 and 65535"
		get_tggui_port($tg_gui_port)
fi
}




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
    mkdir -p "scripts/solutions"
  fi
      SOL_DIR="scripts/solutions/fraud/"
      DEPLOY_FILE=$SOL_DIR"deploy.sh"
      if [ ! -f "$DEPLOY_FILE" ]; then
          echo "--> downloading anti-fraud workshop data"
          wget https://github.com/xpertmind/TigerGraph/raw/master/tigergraph/workshop/fraud.zip
      fi
      unzip fraud.zip
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
      mv $SOL_DIR"/TigerGraph" .
      rm synthea-data.zip
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
# 2 Synthea-Medgraph
# 3 tbd
