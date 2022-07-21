kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-np
minikube service prometheus-server-np
kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-np
minikube service grafana-np
