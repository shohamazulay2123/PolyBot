pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'git-hub-ron', passwordVariable: 'pass', usernameVariable: 'user')]) {


                sh '''
                docker login --username $user --password $pass
                docker build ...
                docker tag ...
                docker push ...
           '''
                }
            }
        }
        stage('Stage II') {
            steps {
                sh 'echo "stage II..."'
            }
        }
        stage('Stage III ...') {
            steps {
                sh 'echo echo "stage III..."'
            }
        }
        stage('Integration Test') {
             steps {
                 sh 'npm install'
                 sh 'npm run test:integration'
             }
         }

    }
}
