#!/bin/bash

# to log into a container
# docker exec -t -i tg_dev3 /bin/bash

echo "----> Starting deployment of Anti-Fraud solution ..."

echo "    ---- Waiting for MariaDB to revive ..."
while ! docker exec mariadb mysql --user=tigergraph --password=tigergraph --host="mariadb" --protocol="tcp" --execute 'SELECT 1;' > /dev/null 2>&1;  do
    sleep 1
done
echo "    ---- Initializing MariaDB Database (DDL) ..."
docker exec -i mariadb sh -c 'mysql -utigergraph -ptigergraph --default_character_set utf8mb4' < $SOL_DIR/tg_mariadb_ddl.sql
# granting privileges to user tigergraph
docker exec -i mariadb sh -c 'mysql -uroot -proot' < $SOL_DIR/tg_mariadb_grant_rights.sql

echo "    ---- Configuring Python/Conda/Jupyter"

# Showing URL for Jupyter connection
# Completely disabling authentication might be a better idea (should not be of concern in workshop environment)

docker exec -it -u tigergraph conda bash -c "jupyter notebook list"

# deploying pyTigerGraph
for F in `ls ./scripts/solutions/fraud/*.py` ; do
    docker cp $F conda:/home/tigergraph
done
# Deploying notebooks
for F in `ls ./scripts/solutions/fraud/*.ipynb` ; do
    docker cp $F conda:/home/tigergraph
done

echo "    ---- Configuring Kafka streaming platform:"
# configuring source connector
echo "    ---- deploying MariaDB source connector ---"
curl -i -X POST localhost:8083/connectors/ -H "Accept:application/json" -H "Content-Type:application/json" -d @$SOL_DIR/debezium-mariadb-sink.json

echo "    ---- deploying TG sink connector "

docker-compose exec kafka sh -c "./bin/kafka-topics.sh --create --topic mariadb.tgdemo.merchant --zookeeper zookeeper:2181 --partitions 1 --replication-factor 1"
docker-compose exec kafka sh -c "./bin/kafka-topics.sh --create --topic mariadb.tgdemo.customer --zookeeper zookeeper:2181 --partitions 1 --replication-factor 1"
docker-compose exec kafka sh -c "./bin/kafka-topics.sh --create --topic mariadb.tgdemo.transaction --zookeeper zookeeper:2181 --partitions 1 --replication-factor 1"
docker-compose exec kafka sh -c "./bin/kafka-topics.sh --create --topic mariadb.tgdemo.category --zookeeper zookeeper:2181 --partitions 1 --replication-factor 1"

# check if created
# curl -H "Accept:application/json" localhost:8083/connectors/

# check the status
# curl -H "Accept:application/json" localhost:8083/connectors/tgfraud-demo/status

# to delete this connector:
# curl -X DELETE http://localhost:8083/connectors/fraud-connector-source

# to check all topics
#  docker-compose exec kafka sh -c "./bin/kafka-topics.sh --zookeeper zookeeper:2181 --list"

# docker-compose exec kafka sh -c "./bin/kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic mariadb.tgdemo.category --from-beginning" | jq .

# check messages
# docker exec -t -i kafka ./bin/kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic mariadb.tgdemo.category --from-beginning --max-messages 2
# ./bin/kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic mariadb.tgdemo.category --from-beginning --max-messages 2

echo "    ---- Waiting for TigerGraph to start roaring ..."
while ! docker exec tg_dev3 curl --fail http://localhost:9000/echo &> /dev/null ; do
    sleep 1
done
echo "    ---- Initializing TigerGraph database (DDL) ..."
docker exec -it --user tigergraph tg_dev3 sh -c "/opt/tigergraph/app/cmd/gsql /home/tigergraph/scripts/FraudGraph_ddl.gsql"

echo "    ---- Configuring Data Loader in TigerGraph"
docker exec -it --user tigergraph tg_dev3 sh -c "/opt/tigergraph/app/cmd/gsql /home/tigergraph/scripts/FraudGraph_KafkaLoadJob.gsql"

echo "    ---- Importing MariaDB transaction data ..."
gunzip < $SOL_DIR/tg_mariadb_data.sql.gz | docker exec -i mariadb mysql -D tgdemo -utigergraph -ptigergraph --default_character_set utf8mb4 &

echo "    ---- Initializing TigerGraph queries (GSQL) ..."
docker exec -it --user tigergraph tg_dev3 sh -c "/opt/tigergraph/app/cmd/gsql /home/tigergraph/scripts/FraudGraph_Queries.gsql"

# cleanups !!!
# (delete scripts and data not used!)
echo "--> Done deployment Fraud!"
