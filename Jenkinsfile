pipeline {
agent {
    docker {
        image 'jenkins_agent:latest'
        args  '--user root -v "//./pipe/docker_engine:/var/run/docker.sock"'
    }
}
     environment {
        MY_GLOBAL_VARIABLE = 'some value'
        timestamp = '%date:~10,4%%date:~4,2%%date:~7,2%%time:~0,2%%time:~3,2%%time:~6,2%'
    }
    options {
    buildDiscarder(logRotator(daysToKeepStr: '3'))
    disableConcurrentBuilds()
    timestamps()
        timeout(time: 10, unit: 'MINUTES')
}
    stages {
        stage('Build Bot app') {
   steps {
   withCredentials([usernamePassword(credentialsId: 'DockerTokenID', passwordVariable: 'myaccesstoken', usernameVariable: 'happytoast')]) {
    // some block
            bat "docker login --username $shohamazulay2123 --password $myaccesstoken"
            bat "docker build -t build_bot:${BUILD_NUMBER} ."
            bat "docker tag build_bot:${BUILD_NUMBER} happytoast/build_bot:${BUILD_NUMBER}"
            bat "docker push happytoast/build_bot:${BUILD_NUMBER}"
           }
       }//steps
   }//stage
        stage('Build') {
            steps {
                bat 'set'
            }
        }//stage
    }//stages
 post {
        always {
            bat "docker rmi happytoast/build_bot:${BUILD_NUMBER}"
        }
    }
}
