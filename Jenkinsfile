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
    stage("back-end(build and push)"){
      steps{
        dir ("spring-boot-student-app-api"){
          // Run Maven on a Unix agent.
          sh "mvn -Dmaven.test.failure.ignore=true clean package dockerfile:push"
        }
        
       }
    }
    stage("font-end(buld and push)"){
      steps{
        dir ("react-student-management-web-app"){
          // Run Maven on a Unix agent.
          sh "docker build . -t thangsu/student-app-client:latest"
          sh 'docker push thangsu/student-app-client:latest'
          }
        }
     }
     stage("deloy"){
	    steps{
          sh 'export check=`helm list | grep hehe`'
          dir("helm"){
            if (env.check == '') {
              sh 'helm install hehe .'
            } else {
              sh 'helm upgrade hehe .'
            }
          }
	      }  
     }
  }
}
