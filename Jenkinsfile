pipeline {
agent any
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
