FROM golang:1.14.9-alpine3.11 AS builder
ADD app /app
WORKDIR /app
RUN apk add --no-cache ca-certificates git && \
    go build -o main .

FROM alpine:3.11 AS app
WORKDIR /app
COPY --from=builder /app/main /app
ENTRYPOINT ["./main"]
