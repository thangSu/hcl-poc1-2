pipeline {
agent any
tools {
  // Install the Maven version configured as "M3" and add it to the path.
   maven '/usr/bin/mvn'
}
stages {
  stage("clean"){
    steps{
      sh "docker image rm thangsu/student-app-client:latest"
      sh "docker image rm registry.hub.docker.com/thangsu/student-app-api:0.0.1-SNAPSHOT "
    }
  }
  stage("back-end"){
    steps{
      dir ("spring-boot-student-app-api"){
        // Run Maven on a Unix agent.
        sh "mvn -Dmaven.test.failure.ignore=true clean package dockerfile:push"
      }
    }
  }
  stage("font-end"){
    steps{
      dir ("react-student-management-web-app"){
        // Run Maven on a Unix agent.
        sh "docker build . -t thangsu/student-app-client:latest"
        //sh 'docker push thangsu/student-app-client:latest'
        }
      }
   }
   }
}
