# CSC3104 Cloud Computing

## Setup

### Docker & Docker Compose

1. Start containers

    `./start.sh`

2. Stop containers

    `./stop.sh`

### Kubernetes

1. Create K8s namespace

    `kubectl apply -f ./namespace.yaml`

2. Start cluster

    `kubectl apply -f .`

3. Stop cluster

    `kubectl delete -f .`
