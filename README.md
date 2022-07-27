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
| Docker      | 1.12.2    |
## Installation steps
### Step 1: create a intance: 
    - OS: Amazon linux
    - Instance tpye: t2.xLarge
    - Storage: 30GB

### _Step 2: update system:_
	sudo yum update
### _Step 3: install required applications_
Run bash script file : `install_package.sh` to install them.
#### Install docker
	sudo yum install docker -y
	sudo systemctl start docker
	sudo usermod -aG docker $USER 
	#this command is used to make current user can run docker commands. We will add that user to docker user group.
#### Install jenkins

	sudo yum install java-1.8.0 -y 
	# it is software requirement when installing jenkins
	sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo 
 	sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
	sudo yum upgrade -y
	sudo yum install jenkins -y
Add jenkins to docker group and start jenkins server

	sudo usermod -aG docker jenkins 
	sudo systemctl enable jenkins #enable the Jenkins service to start at boot
	sudo systemctl start jenkins # start the Jenkins service
#### Install minikube

	curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 
	chmod +x minikube
	sudo mkdir -p /usr/local/bin/
	sudo install minikube /usr/local/bin/
we need to install conntrack because it is enable to start minikube in none driver
	sudo yum install conntrack -y
#### Install kubectl and helm
install kubectl

	curl -LO https://storage.googleapis.com/kubernetes-release/release/
	curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
	chmod +x ./kubectl
	sudo mv ./kubectl /usr/local/bin/kubectl

install helm 

	curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
	chmod 700 get_helm.sh
	./get_helm.sh
### _Step 4: create cluster_
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
### _Step 5: create CI/CD with Jenkins_
#### Connect jenkins to minikube cluster
- First time, we will connect jenkins to minikube cluster. Copy 2 foldes .minikube and .kube in home folder of user start minikube. And change user of them to Jenkins user.

		sudo cp -r .minikube/ .kube/ /var/lib/jenkins/
		sudo chown -R jenkins /var/lib/jenkins/.minikube /var/lib/jenkins/kube
- change the path of 

#### Create jenkins job
- Get admin password to first login Jenkins. Use this command:

		sudo cat /var/lib/jenkins/secrets/initialAdminPassword
- Create jenkins pipline:

<img src="https://github.com/thangSu/thang-poc2/blob/master/data/MicrosoftTeams-image1%20(3).png" alt="drawing" width="200"/>
- make a trigger:

![](https://github.com/thangSu/thang-poc2/blob/master/data/MicrosoftTeams-image1%20(2).png)
- store Jenkins file into repo and we will use Pipeline: SCM to implement that file.

![](https://github.com/thangSu/thang-poc2/blob/master/data/MicrosoftTeams-image1%20(1).png)
	
#### Add github webhook

![](https://github.com/thangSu/thang-poc2/blob/master/data/Annotation%202022-07-25%20155115.png)
### _Step 6: Deloy helm chart_
#### Create jenkinsfile
Integrate helm in the Jenkins pipeline so that it uses these helm charts to

- Deploy React application on Kubernetes
- Deploy MongoDB persistance layer on Kubernetes
- Deploy Spring Boot Backend API on Kubernetes
- Deploy Istio and expose services using Istio VirtualService and Gateway and connect frontend to backend.
- Deploy Prometheus and graffana and able to monitor using them.
#### Deloy helm chart by CI/CD
After deloying, we run this command:

	kubectl get all -A # this command show pod,svc,.. in all namespace. 
	
![](https://github.com/NguyenTienHCL/POC-L1/blob/main/MicrosoftTeams-image%20(4).png)
And check the list helm chart was deloyed:
	
	helm list -A
	
![](https://github.com/NguyenTienHCL/POC-L1/blob/main/MicrosoftTeams-image%20(5).png)
### _Step 7: check CI/CD pipeline_
- Try to access the application from minikube ip.
- And make a change to check CI/CD pipeline. In line 16 change "Student Management APP" to "Student Management Appl" and push the changes to github in order to trigger a new build.
- avigate to this app by ip minikube. verify this change.
