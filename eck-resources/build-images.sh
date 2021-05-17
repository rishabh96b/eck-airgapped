
#!/bin/bash

# This script will pull the images necessary for elastic cloud on k8s
# and create artifacts that can be transferred to bastion host for 
# eck deployment

checkStatus() {
	if [ $1 -eq 0 ]; then
		echo "$2 🍏"
	else
		echo "$2 🍎"
	fi 
}

# Pull eck images
docker pull docker.elastic.co/eck/eck-operator:1.5.0
docker pull docker.elastic.co/elasticsearch/elasticsearch:7.12.1
docker pull docker.elastic.co/kibana/kibana:7.12.1

# Create images folder
rm -rf ./images && mkdir ./images

echo "Creating tarballs for eck images"
echo "................................\n"
# Create tarballs
docker save docker.elastic.co/eck/eck-operator:1.5.0 > images/eck-operator-1.5.0.tar.gz
checkStatus $? "ECK-OPERATOR"

docker save docker.elastic.co/elasticsearch/elasticsearch:7.12.1 > images/elasticsearch-7.12.1.tar.gz
checkStatus $? "ELASTICSEARCH"

docker save docker.elastic.co/kibana/kibana:7.12.1 > images/kibana-7.12.1.tar.gz
checkStatus $? "KIBANA"