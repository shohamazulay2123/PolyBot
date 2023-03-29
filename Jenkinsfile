pipeline {
       agent {
        docker {
            image 'jenkins-agent:latest'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    } 
    
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
                withCredentials([usernamePassword(credentialsId: 'docker', passwordVariable: 'myaccesstoken', usernameVariable: 'happytoast')]) {
                    sh "docker login --username $happytoast --password $myaccesstoken"
                    sh "docker build -t build_bot:${BUILD_NUMBER} ."
                    sh "docker tag build_bot:${BUILD_NUMBER} happytoast/build_bot:${BUILD_NUMBER}"
                }
            }
        }
        stage('Snyk Test') {
            steps {
                withCredentials([string(credentialsId: 'SnykToken', variable: 'SNYK_TOKEN')]) {
                    sh "snyk container test --severity-threshold=critical build_bot:${BUILD_NUMBER} --file=Dockerfile --token=${SNYK_TOKEN} --exclude-base-image-vulns"
                }
            }
        }
        stage('Push Bot App') {
            steps {
                sh "docker push happytoast/build_bot:${BUILD_NUMBER}"
            }
        }
    }
    post {
        always {
            sh "docker rmi shohama/polybot:${BUILD_NUMBER}"
        }
    }
}
