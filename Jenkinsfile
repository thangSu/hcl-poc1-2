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
          sh "docker build . -t thangsu/student-app-client:1.0.8"
          sh 'docker push thangsu/student-app-client:1.0.8'
          }
        }
     }
    stage("deploy or update api and client"){
	    steps{
          dir("helm"){  
            sh 'helm upgrade hehe . --install'
          }
        }
	  } 
    stage("deploy istio"){
      steps{
        //add repo
        sh 'helm repo add istio https://istio-release.storage.googleapis.com/charts'
        sh 'helm repo update'
	//install istio
        sh 'helm upgrade istio-base istio/base -n istio-system --install '
        sh 'helm upgrade istiod istio/istiod -n istio-system -n istio-system --install '
	//install istio-ingress
        sh 'kubectl label namespace default istio-injection=enabled --overwrite'
        sh 'helm upgrade istio-ingress istio/gateway  -f istio/custom_gw.yaml --wait --install'
        
      }
    }
    stage("deploy prometheus and grafana"){
      steps{
        dir ("monitoring"){
              sh "helm upgrade prometheus prometheus --install"
              sh "helm upgrade grafana grafana --install"
          }
        }
      } 
    }
}
