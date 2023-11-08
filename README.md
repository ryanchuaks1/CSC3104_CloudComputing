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

2. Start backend services

    `kubectl apply -f ./zookeeper.yaml`

    `kubectl apply -f ./kafka.yaml`

    `kubectl apply -f ./mariadb.yaml`

3. Start server services

    `kubectl apply -f ./consumer.yaml`

    `kubectl apply -f ./producer.yaml`

    `kubectl apply -f ./server.yaml`

4. Stop cluster

    `kubectl delete -f .`
