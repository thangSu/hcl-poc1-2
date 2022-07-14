#!/bin/bash

## start minikube
minikube  start --driver=none --kubernetes-version v1.23.8
## enable ingress
minikube addons enable ingress

## install istio
# add repo 
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

kubectl create namespace istio-system
helm install istio-base istio/base -n istio-system
helm install istiod istio/istiod -n istio-system --wait

kubectl label namespace default istio-injection=enabled
helm install istio-ingress istio/gateway -f  --wait
