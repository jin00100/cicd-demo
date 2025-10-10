pipeline {
    agent any

    environment {
        // 定义镜像名称和容器名称，方便后续引用
        IMAGE_NAME = 'my-go-app'
        CONTAINER_NAME = 'go-app-prod'
    }

    stages {
        stage('1. Checkout') {
            steps {
                echo '正在拉取代码...'
                // 从 Git 仓库拉取代码
                checkout scm
            }
        }

        stage('2. Build Go Binary') {
            steps {
                echo '正在编译Go程序...'
                // 使用一个临时的 Go 语言容器来编译程序
                // --rm: 运行后自动删除; -v: 挂载当前工作区
                sh 'docker run --rm -v "$WORKSPACE":/app -w /app golang:1.18 go build -o main .'
            }
        }

        stage('3. Build Docker Image') {
            steps {
                echo "正在构建Docker镜像: ${IMAGE_NAME}:${BUILD_NUMBER}"
                // 使用项目中的 Dockerfile 构建新镜像
                // -t: 给镜像打上标签，我们用 Jenkins 的构建号作为版本
                sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
            }
        }

        stage('4. Deploy') {
            steps {
                echo '正在部署新版本...'
                // 使用 sh 来执行 shell 命令
                // 首先，检查并停止旧的同名容器（如果存在）
                sh "docker ps -q -f name=${CONTAINER_NAME} | xargs -r docker stop"
                // 启动新版本的容器
                sh "docker run -d --rm --name ${CONTAINER_NAME} -p 8888:8080 ${IMAGE_NAME}:${BUILD_NUMBER}"
            }
        }
    }
    
    post {
        always {
            echo '流水线结束。清理旧的镜像...'
            // 清理无用的 Docker 镜像，避免磁盘空间被占满
            sh 'docker image prune -f'
        }
    }
}
