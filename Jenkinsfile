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
                    image: shohama\my-jenkins-agent
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
        stage('Installations') {
            steps {
                install()
            }
        }
        stage('Tests') {
            parallel {
                stage('PylintTest') {
                    steps {
                        sh "python3 -m pylint --exit-zero -f parseable --reports=no *.py > pylint.log"
                    }
                }
                stage('PolyTest') {
                    steps {
                        withCredentials([string(credentialsId: 'telegramToken', variable: 'TELEGRAM_TOKEN')]) {
                            sh "touch .telegramToken"
                            sh "echo ${TELEGRAM_TOKEN} > .telegramToken"
                            sh "python3 -m pytest --junitxml results.xml tests/polytest.py"
                        }
                    }
                }
            }
        }
        stage('Build Bot App') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'DockerTokenID', passwordVariable: 'myaccesstoken', usernameVariable: 'shohama')]) {
                    sh "docker login --username $shohama --password $myaccesstoken"
                    sh "docker build -t build_bot:${BUILD_NUMBER} ."
                    sh "docker tag build_bot:${BUILD_NUMBER} shohama/build_bot:${BUILD_NUMBER}"
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
                sh "docker push shohama/build_bot:${BUILD_NUMBER}"
            }
        }
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
