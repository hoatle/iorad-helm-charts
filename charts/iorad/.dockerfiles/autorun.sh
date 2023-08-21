docker_exec() {
  if hash ct 2>/dev/null; then
    "$@"
  else
    docker exec --interactive ct "$@"
  fi
}

docker_exec kubectl apply -f charts/iorad/.dockerfiles/pvc.yaml

readonly CLUSTER_NAME=${1:-'chart-testing'}
readonly DOCKER_IMAGE="gcr.io/teracy-iorad/${K8S_NAMESPACE:-iorad}/iorad/app:develop"

echo "image pull $DOCKER_IMAGE"
docker image pull $DOCKER_IMAGE

echo "docker tag $DOCKER_IMAGE iorad/app:develop"
docker tag $DOCKER_IMAGE iorad/app:develop

echo "kind load docker-image iorad/app:develop --name $CLUSTER_NAME"
kind load docker-image iorad/app:develop --name $CLUSTER_NAME
