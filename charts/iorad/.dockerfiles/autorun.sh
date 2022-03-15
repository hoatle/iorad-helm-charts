#!/bin/bash
pushd . > /dev/null
SCRIPT_PATH="${BASH_SOURCE[0]}";
if ([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do cd "$(dirname "$SCRIPT_PATH")"; SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
cd "$(dirname ${SCRIPT_PATH})" > /dev/null
SCRIPT_PATH=$(pwd);
popd  > /dev/null

readonly CLUSTER_NAME=${1:-'chart-testing'}

docker exec --interactive ct kubectl apply -f charts/iorad/.dockerfiles/pvc.yaml

if hash ct 2>/dev/null; then
    kubectl apply -f charts/iorad/.dockerfiles/pvc.yaml
else
    docker exec --interactive ct kubectl apply -f charts/iorad/.dockerfiles/pvc.yaml
fi

echo "docker build -t iorad/app:develop $SCRIPT_PATH"

docker build -t iorad/app:develop $SCRIPT_PATH

echo "kind load docker-image iorad/app:develop --name $CLUSTER_NAME"

kind load docker-image iorad/app:develop --name "$CLUSTER_NAME"
