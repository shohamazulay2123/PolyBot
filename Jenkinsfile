@Library("devops22-sharedlib") _
pipeline {
    agent {
        kubernetes {
            defaultContainer 'jenkins-agent'
            yaml '''
                apiVersion: v1
                kind: Pod
                metadata:
                  labels:
                    some-label: jenkins-eks-pod
                spec:
                  serviceAccountName: jenkins
                  containers:
                  - name: jenkins-agent
                    image: shohama/my-jenkins-agent
                    imagePullPolicy: Always
                    volumeMounts:
                     - name: jenkinsagent-pvc
                       mountPath: /var/run/docker.sock
                    tty: true
                  volumes:
                  - name: jenkinsagent-pvc
                    hostPath:
                      path: /var/run/docker.sock
                  securityContext:
                    allowPrivilegeEscalation: false
                    runAsUser: 0
                '''
        }
    }
    environment {
        MY_GLOBAL_VARIABLE = 'some value'
        timestamp = sh(script: 'date "+%Y%m%d%H%M%S"', returnStdout: true).trim()
        SNYK_TOKEN = credentials('SnykToken')
        TELEGRAM_TOKEN = credentials('telegramToken')
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '3'))
        disableConcurrentBuilds()
        timestamps()
        timeout(time: 10, unit: 'MINUTES')
    }
    stages {
        // Stages as before, unchanged
    }
    post {
        always {
            sh "docker rmi shohama/build_bot:${BUILD_NUMBER}"
            junit allowEmptyResults: true, testResults: 'results.xml'
            sh 'cat pylint.log'
            recordIssues (
                enabledForFailure: true,
                aggregatingResults: true,
                tools: [pyLint(name: 'Pylint', pattern: '**/pylint.log')]
            )
        }
    }
}
