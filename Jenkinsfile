pipeline {
    agent any 
    
    environment {
        MY_GLOBAL_VARIABLE = 'some value'
        timestamp = sh(script: 'date "+%Y%m%d%H%M%S"', returnStdout: true).trim()
       
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '3'))
        disableConcurrentBuilds()
        timestamps()
        timeout(time: 10, unit: 'MINUTES')
    }
    stages {
    stage('Build Bot App') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'DockerTokenID', passwordVariable: 'myaccesstoken', usernameVariable: 'shohama')]) {
                    sh "docker login --username $shohama --password $myaccesstoken"
                    sh "docker build -t polybot:${BUILD_NUMBER} ."
                    sh "docker tag polybot:${BUILD_NUMBER} shohama/polybot:${BUILD_NUMBER}"
                 }
            }
        }
      
       
        
        
        stage('Push Bot App') {
            steps {
                    sh "docker push shohama/polybot:${BUILD_NUMBER}"
                }
            }
    }
    post {
        always {
            sh "docker rmi shohama/polybot:${BUILD_NUMBER}"
        }
    }
}
