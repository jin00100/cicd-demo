pipeline {
    agent any

    environment {
        // 定义镜像名称和容器名称
        IMAGE_NAME = 'my-go-app'
        CONTAINER_NAME = 'go-app-prod'
        // 确保 Jenkins shell 能找到 docker
        PATH = "/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
        DOCKER_CMD = "/usr/bin/docker"
    }

    stages {
        stage('Debug PATH') {
            steps {
                sh 'echo $PATH'
                sh '$DOCKER_CMD --version'
            }
        }

        stage('1. Checkout') {
            steps {
                echo '正在拉取代码...'
                checkout scm
            }
        }

        stage('2. Build Go Binary') {
            steps {
                echo '正在编译Go程序...'
                sh '$DOCKER_CMD run --rm -v "$WORKSPACE":/app -w /app golang:1.18 go build -o main .'
            }
        }

        stage('3. Build Docker Image') {
            steps {
                echo "正在构建Docker镜像: ${IMAGE_NAME}:${BUILD_NUMBER}"
                sh '$DOCKER_CMD build -t ${IMAGE_NAME}:${BUILD_NUMBER} .'
            }
        }

        stage('4. Deploy') {
            steps {
                echo '正在部署新版本...'
                sh '$DOCKER_CMD ps -q -f name=${CONTAINER_NAME} | xargs -r $DOCKER_CMD stop'
                sh '$DOCKER_CMD run -d --rm --name ${CONTAINER_NAME} -p 8888:8080 ${IMAGE_NAME}:${BUILD_NUMBER}'
            }
        }
    }

    post {
        always {
            echo '流水线结束。清理旧的镜像...'
            sh 'docker image prune -f || true'

        }
    }
}

