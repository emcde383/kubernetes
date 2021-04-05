#!/usr/bin/env bash

echo "stop any running containers"
docker kill $(docker ps)

echo "pulling python Docker image from docker hub"
docker pull python

echo "building project image locally"
docker build -t flask_v0 . --label "version=$(git branch)"

echo "showing images for this release"
docker images
docker images | grep flask_v0
docker images --filter "label=version=$(git branch)"

echo "running Docker image for this release"
#docker run -p 5000:5000 flask_v0

echo "testing endpoint from Docker container"
curl localhost:5000/test

echo "starting local Kubernetes cluster"
minikube start
minikube addons enable ingress
minikube addons list | grep ingress

kubectl get pods -n kube system

echo "creating Deployment"
kubectl create -f kubernetes/deployment.yaml

echo "currently running Deployments:"
kubectl get deployments
kubectl get deployments --selector="app=flaskv0"

echo "currently running Pods:"
kubectl get pods
kubectl get pods --selector="version=v0"

echo "creating Service"
kubectl expose deployment flaskv0 --type=LoadBalancer --port=5000

echo "creating Ingress/LoadBalancer"
kubectl create -f kubernetes/ingress.yaml

kubectl rollout status deployment flaskv0

kubectl get events
minikube dashboard