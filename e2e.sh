#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

readonly CT_VERSION=v3.9.0
readonly KIND_VERSION=v0.11.1
readonly CLUSTER_NAME=chart-testing
readonly K8S_VERSION=v1.28.0

docker_opts=""

if [ "$DEV_MODE" = "docker" ]; then
  docker_opts="--platform linux/amd64"
fi

echo "docker_opts: ${docker_opts}"

run_ct_container() {
    echo 'Running ct container...'
    docker run --rm --interactive --detach --network host --name ct \
        --volume "$(pwd)/ct.yaml:/etc/ct/ct.yaml" \
        --volume "$(pwd):/workdir" \
        --workdir /workdir $docker_opts \
        "quay.io/helmpack/chart-testing:$CT_VERSION" \
        cat
    echo
}

cleanup() {
    echo 'Removing ct container...'
    docker kill ct > /dev/null 2>&1

    echo "Removing $CLUSTER_NAME cluster..."
    kind delete cluster --name=$CLUSTER_NAME
    echo 'Done!'
}

docker_exec() {
    docker exec --interactive ct "$@"
}

create_kind_cluster() {
    echo 'Installing kind if not yet...'
    # TODO: need check and install kind if not exist, should work on macOS and Linux

    # curl -sSLo kind "https://github.com/kubernetes-sigs/kind/releases/download/$KIND_VERSION/kind-linux-amd64"
    # chmod +x kind
    # sudo mv kind /usr/local/bin/kind

    kind create cluster --name "$CLUSTER_NAME" --config kind/kind-config.yaml --image "kindest/node:$K8S_VERSION" --kubeconfig=$(pwd)/kind/.kube/config --wait 100s

    echo 'Copying kubeconfig to container...'
    docker exec ct mkdir -p /root/.kube
    docker cp $(pwd)/kind/.kube/config ct:/root/.kube/config

    docker_exec kubectl cluster-info
    echo

    docker_exec kubectl get nodes
    echo

    echo 'Cluster ready!'
    echo
}

create_secrets() {
    readonly GPG_KEY_FILE_BASE64=${GCR_KEY_FILE_BASE64:-}
    if [[ -n "$GPG_KEY_FILE_BASE64" ]]; then
        echo $GPG_KEY_FILE_BASE64 | base64 -d > /tmp/gcp_key_file.json;

        echo 'docker login'

        docker login -u _json_key -p "$(cat /tmp/gcp_key_file.json)" https://gcr.io

        rm /tmp/gcp_key_file.json;
    fi
}

load_kind_docker_image() {
    local changed_list=$(docker_exec ct list-changed --config ct.yaml)

    if [[ -n "$changed_list" ]]; then
        for i in "${changed_list[@]}"
        do
            if  [[ $i == charts/* ]];
            then
                echo "$i"
                find ./$i -name "autorun.sh" -exec chmod +x {} \; -exec {} $CLUSTER_NAME \; || true
            fi
            
        done
    fi    

    docker_exec kubectl get pvc
    echo
}

lint_charts() {
    docker_exec ct lint
    echo
}

install_charts() {
    docker_exec ct install --namespace default
    echo
}

main() {
    run_ct_container
    trap cleanup EXIT
    lint_charts
    create_kind_cluster
    create_secrets
    load_kind_docker_image
    install_charts
}

main
