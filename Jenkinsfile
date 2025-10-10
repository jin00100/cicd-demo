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
                // 调试挂载路径，确认 go.mod 可见
                sh 'ls -l $WORKSPACE'
                // 使用 Go Modules 显式开启，确保编译正确
                sh '''
                    docker run --rm \
                    -v "$WORKSPACE":/app \
                    -w /app \
                    -e GO111MODULE=on \
                    golang:1.18 \
                    go build -o main ./...
                '''
            }
        }

        stage('3. Build Docker Image') {
            steps {
                echo "正在构建Docker镜像: ${IMAGE_NAME}:${BUILD_NUMBER}"
                sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
            }
        }

        stage('4. Deploy') {
            steps {
                echo '正在部署新版本...'
                // 停掉旧容器（如果存在）
                sh "docker ps -q -f name=${CONTAINER_NAME} | xargs -r docker stop"
                // 启动新容器
                sh "docker run -d --rm --name ${CONTAINER_NAME} -p 8888:8080 ${IMAGE_NAME}:${BUILD_NUMBER}"
            }
        }
    }

    post {
        always {
            echo '流水线结束。清理无用Docker镜像...'
            // 失败也不报错
            sh 'docker image prune -f || true'
        }
    }
}

