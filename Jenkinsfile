pipeline {
    agent any

      stages{

        stage('Integration Test') {
             steps {
                 sh 'npm install'
                 sh 'npm run test:integration'
             }
            }

    }
}
