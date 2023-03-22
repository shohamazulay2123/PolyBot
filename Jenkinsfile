// @Library('shared-lib-int') _

//library 'shared-lib-int@main'

pipeline {

    options{
    buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '5', numToKeepStr: '10'))
    disableConcurrentBuilds()
        
   }
    agent{
     docker {
        image 'my-jenkins-agent:1.0'
        args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
    }
    }
    environment{
        SNYK_TOKEN = credentials('snyk-token')
    }
    // parameters { choice(choices: ['one', 'two'], description: 'this is just for testing', name: 'testchioce') }
//snyk container test my-image:latest --file=Dockerfile
    stages {
        stage('Test') {
            parallel {
                stage('pytest') {
                    steps {
                        withCredentials([file(credentialsId: 'telegramToken', variable: 'TELEGRAM_TOKEN')]) {
                        bat "cp ${TELEGRAM_TOKEN} .telegramToken"
                        bat 'pip3 install -r requirements.txt'
                        bat "python3 -m pytest --junitxml results.xml tests/*.py"
                        }
                    }
                }
                stage('pylint') {
                    steps {
                        script { 
                            logs.info 'Starting'
                            logs.warning 'Nothing to do!'
                            bat "python3 -m pylint *.py || true"
                        }
                    }
                }
            }
        }
        stage('Build') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', passwordVariable: 'pass', usernameVariable: 'user')]) {

                  bat "docker build -t ronhad/private-course:poly-bot-${env.BUILD_NUMBER} . "
                  bat "docker login --username $user --password $pass"
                }
            }
        }
        stage('snyk test') {
            steps {
                bat "snyk container test --severity-threshold=critical ronhad/private-course:poly-bot-${env.BUILD_NUMBER} --file=Dockerfile"
            }
        }
        stage('push') {
            steps {
                    bat "docker push ronhad/private-course:poly-bot-${env.BUILD_NUMBER}"
            }

        }
        
    }
}