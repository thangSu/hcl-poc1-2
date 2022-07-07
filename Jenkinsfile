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
    stage("back-end"){
      steps{
        dir ("spring-boot-student-app-api"){
          // Run Maven on a Unix agent.
          sh "mvn -Dmaven.test.failure.ignore=true clean package docker:push"
        }
        
       }
    }
    stage("font-end"){
      steps{
        dir ("react-student-management-web-app"){
          // Run Maven on a Unix agent.
          sh "docker build . -t thangsu/student-app-client:latest"
          sh 'docker push thangsu/student-app-client:latest'
          }
        }
     }
  }
}
