FROM alpine

COPY main /app/main

WORKDIR /app

EXPOSE 8080

CMD ["./main"]

