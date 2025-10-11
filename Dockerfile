# 使用Go官方镜像构建
FROM golang:1.18 as builder
WORKDIR /app
COPY . .
RUN go build -o main .

# 第二阶段，精简运行镜像
FROM alpine:3.18
WORKDIR /root/
COPY --from=builder /app/main .
EXPOSE 8080
CMD ["./main"]

