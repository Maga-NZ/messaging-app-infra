// Jenkinsfile
pipeline {
    agent any

    environment {
        AWS_REGION = 'us-west-2'
        ECR_REPOSITORY_URI = '010526257977.dkr.ecr.us-west-2.amazonaws.com/messaging-app'
        DOCKER_IMAGE_NAME = "${ECR_REPOSITORY_URI}:${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Checking out code...'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${env.DOCKER_IMAGE_NAME} ."
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                script {
                    def ecrLogin = sh(returnStdout: true, script: "aws ecr get-login-password --region ${env.AWS_REGION}").trim()
                    sh "docker login --username AWS --password-stdin ${env.ECR_REPOSITORY_URI} <<< ${ecrLogin}"
                    sh "docker push ${env.DOCKER_IMAGE_NAME}"
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished (always).'
        }
    }
}
