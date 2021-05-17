#!/bin/bash


SCRIPT=$(basename "${BASH_SOURCE[0]}")

# Help instructions for reference
help() {
echo "
Basic Commands:
${SCRIPT} init --registry 10.0.0.1:5000
  - This will get the registry and retag the docker images and push to local registry. 
  - It will also parse the template files will the retagged images.
Deploy Commands
${SCRIPT} install operator
  - install command will install eck operator with default options
${SCRIPT} install elasticsearch
  - install elasticsearch with default options
${SCRIPT} install kibana
  - installs kibana with default options
${SCRIPT} install apm 
  - installs apm with default options
${SCRIPT} logs operator
  - show the logs for deployed eck operator
  - kubectl -n elastic-system logs -f statefulset.apps/elastic-operator
"
exit 1
}

# Retag and push eck-operator image
retagAndPushECK() {
  if [ "$1" == "" ]; then
    echo "Registry cannot be empty. Please try again."
    exit 1
  fi
  # Tagging and pushing eck-operator image
  echo "Loading  eck-operator image"
  docker load -i images/eck-operator-1.5.0.tar.gz
  echo "Pushing image to $1 registry"
  docker image tag docker.elastic.co/eck/eck-operator:1.5.0 $1/eck-operator:1.5.0
  docker push $1/eck-operator:1.5.0
  
}
# TODO: @rishabh create templates for docker image versions and tar files.
retagAndPush() {
  case "$1" in
    operator)
      echo "Loading  eck-operator image"
      docker load -i images/eck-operator-1.5.0.tar.gz
      echo "Pushing image to $2 registry"
      docker image tag docker.elastic.co/eck/eck-operator:1.5.0 $2/eck-operator:1.5.0
      docker push $2/eck-operator:1.5.0
      ;;
    elastic)
      echo "Loading  elasticsearch image"
      docker load -i images/elasticsearch-7.12.1.tar.gz
      echo "Pushing image to $2 registry"
      docker image tag docker.elastic.co/elasticsearch/elasticsearch:7.12.1 $2/elasticsearch:7.12.1
      docker push $2/elasticsearch:7.12.1
      ;;
    kibana)
      echo "Loading  kibana image"
      docker load -i images/kibana-7.12.1.tar.gz
      echo "Pushing image to $2 registry"
      docker image tag docker.elastic.co/kibana/kibana:7.12.1 $2/kibana:7.12.1
      docker push $2/kibana:7.12.1
      ;;
    *)
      echo "Unable to retag and push image. Please provide suitable param"
      echo "Expected operator,elastic,kibana; Got $1"
      exit 1
      ;;
  esac
}

# Retag and push elastic docker image

NUMARGS=$#
# echo -e \\n"Number of arguments: $NUMARGS"
if [ $NUMARGS -eq 0 ]; then
  help
fi

case "$1" in
  init)
    if [ "$2" == "--registry" ]; then
    USER_REGISTRY="$3"
    retagAndPush "operator" $USER_REGISTRY
    # Create a folder for rendered files
    mkdir deployments
    # Move templates to deployment folder
    cp -a templates/* deployments/
    # Replace the registry variable
    find ./deployments/ -type f -exec sed -i "s/\$REGISTRY/$USER_REGISTRY/g" {} \;
    else 
      echo "--registry flag not set."
      help
      exit 1
    fi
    ;;
  install)
    case "$2" in
      operator)
      echo "Deploying ECK operator"
        kubectl create -f deployments/all-in-one.yaml
        ;;
      elasticsearch)
        kubectl create -f deployments/elasticsearch.yaml
        ;;
      kibana)
        kubectl create -f deployments/kibana.yaml
        ;;
      *)
        help
        ;;
    esac
    ;;
  logs)
    case "$2" in
      operator)
        echo "Fetching eck-operator logs"
        kubectl -n elastic-system logs -f statefulset.apps/elastic-operator
        ;;
      *)
        help
        ;;
    esac
    ;;
  *)
    help
    ;;
esac

