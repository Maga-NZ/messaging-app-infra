// Jenkinsfile
pipeline {
    agent any

    environment {
        AWS_REGION = 'YOUR_AWS_REGION'
        ECR_REPOSITORY_URI = 'YOUR_ECR_REPOSITORY_URI'
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
