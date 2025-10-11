pipeline {
    agent any

    environment {
        IMAGE_NAME = 'my-go-app'
        CONTAINER_NAME = 'go-app-prod'
    }

    stages {
        stage('1. Checkout') {
            steps {
                echo '🔄 正在拉取代码...'
                checkout scm
            }
        }

        stage('2. Build Go Binary') {
            steps {
                echo '🔨 编译 Go 程序...'
                sh 'docker run --rm -v "$WORKSPACE":/app -w /app golang:1.18 go build -o main .'
            }
        }

        stage('3. Build Docker Image') {
            steps {
                echo "🐳 构建 Docker 镜像: ${IMAGE_NAME}:${BUILD_NUMBER}"
                sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
            }
        }

        stage('4. Deploy') {
            steps {
                echo '🚀 启动新容器...'
                sh "docker ps -q -f name=${CONTAINER_NAME} | xargs -r docker stop"
                sh "docker run -d --rm --name ${CONTAINER_NAME} -p 8888:8080 ${IMAGE_NAME}:${BUILD_NUMBER}"
            }
        }
    }

    post {
        always {
            echo '🧹 清理无用镜像...'
            sh 'docker image prune -f || true'
        }
    }
}

