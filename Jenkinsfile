pipeline {
agent any
  environment {
     DOCKERHUB_CREDENTIALS=credentials('ThangDocker')
  }
  stages {
    stage('Login') {
      steps {
          sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
        }
		}
    stage("back-end(build and push student-app-api)"){
      steps{
        dir ("spring-boot-student-app-api"){
          // Run Maven on a Unix agent.
          sh "mvn -Dmaven.test.failure.ignore=true clean package dockerfile:push"
        }
        
       }
    }
    stage("font-end(buld and push student-app-client)"){
      steps{
        dir ("react-student-management-web-app"){
          // Run Maven on a Unix agent.
          sh "docker build . -t thangsu/student-app-client:1.0.2"
          sh 'docker push thangsu/student-app-client:1.0.2'
          }
        }
     }
    stage ("prepair"){
      steps{
        sh 'unset check check_istiod check_istiod'
      }
    }
    stage("deploy or update api and client"){
	    steps{
          sh 'export check=`helm list | grep hehe`'
          dir("helm"){  
          script{
             if(env.check == ''){
              sh 'helm install hehe .'
            } else {
              sh 'helm upgrade hehe .'
            }
          } 
          }
        }
	  } 
    stage("deploy istio"){
      steps{
        sh 'export check_istiod=`helm list -A | grep istiod`'
        sh 'export check_istiod=`helm list -A | grep istio-base`'
        sh 'export check_istioingress=`helm list -A | grep istio-ingress`'
        //add repo
        sh 'helm repo add istio https://istio-release.storage.googleapis.com/charts'
        sh 'helm repo update'
        script {
          if (env.check_istiobase == ""){
            sh 'kubectl create namespace istio-system'
            sh 'helm install istio-base istio/base -n istio-system'
          }
        }
        script {
          if (env.check_istiod ==""){
            sh 'helm install istiod istio/istiod -n istio-system --wait'
          }
        }
        dir("istio"){
          script {
            if (env.check_istioingress == "")
            sh 'kubectl label namespace default istio-injection=enabled'
            sh 'helm install istio-ingress istio/gateway  -f custom_gw.yaml --wait'
          } 
        }
        
      }
    }
    stage("deploy prometheus and grafana"){
      steps{
        dir ("monitoring"){
          // deloy prometheus
          sh 'export check_prometheus=`helm list -A | grep prometheus`'
          script {
            if (env.check_prometheus == "" ){
              sh "helm install prometheus prometheus"
              sh 'kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-np'
              sh 'minikube service prometheus-server-np'
            }
            else{
              sh 'helm upgrade prometheus prometheus'
            }
          }
          // deloy grafana
          sh 'export check_grafana=`helm list -A | grep grafana`'
          script{
            if(env.check_grafana == ""){
               sh "helm install grafana grafana"
               sh "kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-np"
               sh "minikube service grafana-np"
            }else{
              sh 'helm upgrade grafana grafana'
            }
          }
        }
     } 
     }
  }
}
