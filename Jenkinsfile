pipeline {
    agent any

    environment {
        IMAGE_NAME = 'my-go-app'
        CONTAINER_NAME = 'go-app-prod'
    }

    stages {
        stage('1. Checkout') {
            steps {
                echo '正在拉取代码...'
                checkout scm
            }
        }

        stage('2. Build Go Binary') {
            steps {
                echo '正在编译Go程序...'
                // 确保挂载目录正确，并使用 go modules
                sh '''
                    docker run --rm -v "$WORKSPACE":/app -w /app golang:1.18 \
                    sh -c "go mod tidy && go build -o main ."
                '''
            }
        }

        stage('3. Build Docker Image') {
            steps {
                echo "正在构建Docker镜像: ${IMAGE_NAME}:${BUILD_NUMBER}"
                sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} $WORKSPACE"
            }
        }

        stage('4. Deploy') {
            steps {
                echo '正在部署新版本...'
                sh "docker ps -q -f name=${CONTAINER_NAME} | xargs -r docker stop || true"
                sh "docker run -d --rm --name ${CONTAINER_NAME} -p 8888:8080 ${IMAGE_NAME}:${BUILD_NUMBER}"
            }
        }
    }

    post {
        always {
            echo '流水线结束。清理无用镜像...'
            sh 'docker image prune -f'
        }
    }
}

