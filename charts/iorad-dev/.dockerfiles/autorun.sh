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

docker exec --interactive ct kubectl apply -f charts/iorad-dev/.dockerfiles/pvc.yaml

echo "docker build -t iorad/iorad-dev-app $SCRIPT_PATH"

docker build -t iorad/src -f $SCRIPT_PATH/Dockerfile-src $SCRIPT_PATH
docker build -t iorad/iorad-dev-app -f $SCRIPT_PATH/Dockerfile-app $SCRIPT_PATH
docker build -t iorad/iorad-dev-node -f $SCRIPT_PATH/Dockerfile-node $SCRIPT_PATH

echo "kind load docker-image iorad/iorad-dev-app iorad/iorad-dev-node iorad/src --name $CLUSTER_NAME"

kind load docker-image  iorad/src iorad/iorad-dev-node iorad/iorad-dev-app --name $CLUSTER_NAME
