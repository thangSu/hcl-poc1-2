## Description
- Create EC2 instance with Kubernetes cluster using minikube.
- Create CI in Jenkins to create docker image and push the images to docker-hub registry.
- Create CD in Jenkins to use docker hub images and deploy application components on Kubernetes cluster using helm.
## Prerequisites
| name  | version |
| ------------- | ------------- |
|  Minikube | 1.23.8    |
| Jenkins     |  2.346.2 |
| Maven      |  3.6.3     |
| Kubectl     | 1.24.0    |
| Helm         | 3.0.0     |
| Docker      ||

### step 1: create a intance: 
    - OS: Amazon linux
    - Instance tpye: t2.xLarge
    - Storage: 30GB

### step 2: update system:
   `sudo yum update`
### step 3: install required applications by running bash script file : `install_package.sh`
#### install docker
	sudo yum install docker -y
	sudo systemctl start docker
	sudo usermod -aG docker $USER #this command is used to make current user can run docker commands. We will add that user to docker user group.
#### install jenkins

	sudo yum install java-1.8.0 -y # it is software requirement when installing jenkins
	sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo 
 	sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
	sudo yum upgrade -y
	sudo yum install jenkins -y
Add jenkins to docker group and start jenkins server

	sudo usermod -aG docker jenkins 
	sudo systemctl enable jenkins #enable the Jenkins service to start at boot
	sudo systemctl start jenkins # start the Jenkins service
#### install minikube
	curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube
	sudo mkdir -p /usr/local/bin/
	sudo install minikube /usr/local/bin/
we need to install conntrack because it is enable to start minikube in none driver
#### install kubectl and helm
install kubectl

	curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
	chmod +x ./kubectl
	sudo mv ./kubectl /usr/local/bin/kubectl

install helm 

	curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
	chmod 700 get_helm.sh
	./get_helm.sh
### step 4: create cluster
After install all required applications, we will start the Minikube. Run `install_kube.sh` that script file have necessary commands to start one cluster.

	minikube  start --driver=none --kubernetes-version v1.23.8 #this command is used to start minikube
	minikube addons enable ingress
We install istio by using Helm:

	helm repo add istio https://istio-release.storage.googleapis.com/charts
	helm repo update
	kubectl create namespace istio-system
	helm install istio-base istio/base -n istio-system
	helm install istiod istio/istiod -n istio-system --wait
	kubectl label namespace default istio-injection=enabled
	helm install istio-ingress istio/gateway -f   --wait
### step5: create CI/CD with Jenkins


