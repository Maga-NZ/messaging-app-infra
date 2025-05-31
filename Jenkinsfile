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
        // BUILD_NUMBER - это встроенная переменная Jenkins, представляющая номер сборки
        DOCKER_IMAGE_NAME = "${ECR_REPOSITORY_URI}:${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Checking out code...'
                // Этот шаг обычно выполняется автоматически при настройке Pipeline из SCM,
                // но явно его можно добавить так (хотя часто он избыточен в Declarative Pipeline):
                // checkout scm
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
                    // Убедитесь, что AWS CLI установлен и настроен (credentials) на инстансе Jenkins
                    def ecrLogin = sh(returnStdout: true, script: "aws ecr get-login-password --region ${env.AWS_REGION}").trim()
                    // Login Docker to ECR using the obtained token
                    sh "docker login --username AWS --password-stdin ${env.ECR_REPOSITORY_URI} <<< ${ecrLogin}"
                    // Push the image to ECR
                    sh "docker push ${env.DOCKER_IMAGE_NAME}"
                }
            }
        }

        // Пример дополнительной стадии (опционально)
        // stage('Deploy') {
        //     steps {
        //         echo 'Deploying the application...'
        //         // Здесь могут быть шаги для деплоя, например, обновление сервиса ECS, Kubernetes и т.д.
        //     }
        // }
    }

    post {
        // Actions to be performed after the entire pipeline finishes
        // Эти блоки выполняются напрямую, БЕЗ ДОПОЛНИТЕЛЬНОГО БЛОКА steps {}
        always {
            // Этот блок выполняется всегда, независимо от статуса стадии
            echo 'Pipeline finished (always).'
            // Cleanup (optional, but recommended to save space)
            // cleanWs() // Очистка рабочего пространства после сборки
        }
        // success {
        //     // Этот блок выполняется только в случае успешного завершения всех стадий
        //     echo 'Pipeline finished successfully.'
        // }
        // failure {
        //     // Этот блок выполняется только в случае неудачи в какой-либо стадии
        //     echo 'Pipeline failed.'
        // }
    }
}
