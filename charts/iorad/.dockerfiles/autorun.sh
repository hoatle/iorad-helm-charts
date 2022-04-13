docker_exec() {
  if hash ct 2>/dev/null; then
    "$@"
  else
    docker exec --interactive ct "$@"
  fi
}

docker_exec kubectl apply -f charts/iorad/.dockerfiles/pvc.yaml

readonly CLUSTER_NAME=${1:-'chart-testing'}

echo "docker pull gcr.io/teracy-iorad/iorad/iorad/app:develop"
docker pull gcr.io/teracy-iorad/iorad/iorad/app:develop

echo "kind load docker-image gcr.io/teracy-iorad/iorad/iorad/app:develop --name $CLUSTER_NAME"
kind load docker-image gcr.io/teracy-iorad/iorad/iorad/app:develop --name $CLUSTER_NAME