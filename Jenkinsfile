// Jenkinsfile
pipeline {
    agent any // Defines where the pipeline will run. 'any' means on any available agent (in our case, the EC2 instance)

    environment {
        // Environment variables available in the pipeline
        // Replace 'YOUR_AWS_REGION' with your actual AWS region (e.g., 'us-west-2')
        AWS_REGION = 'YOUR_AWS_REGION'
        // Replace 'YOUR_ECR_REPOSITORY_URI' with the URI of your ECR repository
        // It will look something like: <aws_account_id>.dkr.ecr.<region>.amazonaws.com/<repository_name>
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
                echo "Building Docker image: ${env.DOCKER_IMAGE_NAME}"
                // Ensure your Dockerfile is in the project root directory
                script {
                    // Docker build command. '.' indicates the current directory as the build context
                    sh "docker build -t ${env.DOCKER_IMAGE_NAME} ."
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                echo "Pushing Docker image to ECR: ${env.DOCKER_IMAGE_NAME}"
                script {
                    // Get authorization token for ECR
                    // AWS CLI must be installed on the Jenkins agent (EC2 instance)
                    def ecrLogin = sh(returnStdout: true, script: "aws ecr get-login-password --region ${env.AWS_REGION}").trim()
                    // Login Docker to ECR using the obtained token
                    sh "docker login --username AWS --password-stdin ${env.ECR_REPOSITORY_URI} <<< ${ecrLogin}"
                    // Push the image to ECR
                    sh "docker push ${env.DOCKER_IMAGE_NAME}"
                }
            }
        }
    }
    post {
        // Actions to be performed after the entire pipeline finishes
        always {
            steps {
                // Cleanup (optional, but recommended to save space)
                // cleanWs()
            }
        }
    }
}