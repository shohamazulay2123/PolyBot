pipeline {
    agent any

      Stages{

        stage('Integration Test') {
             steps {
                 sh 'npm install'
                 sh 'npm run test:integration'
             }
            }

    }
}
