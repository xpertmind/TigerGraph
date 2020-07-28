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
docker-compose up -d

if [ "$1" == "1" ]; then
      SOL_DIR="scripts/solutions/fraud/"
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
