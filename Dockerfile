# 第一阶段：编译
FROM golang:1.18 AS builder
WORKDIR /app
COPY . .
RUN go build -o main .

# 第二阶段：运行
FROM alpine
WORKDIR /app
COPY --from=builder /app/main .
EXPOSE 8080
CMD ["./main"]

