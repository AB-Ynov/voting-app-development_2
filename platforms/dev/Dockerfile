# Build Stage
FROM golang:1.16 AS build
WORKDIR /app
COPY . .
RUN go build -o voting-app

# Final Stage
FROM alpine:latest
WORKDIR /app
COPY --from=build /app/voting-app .
CMD ["./voting-app"]
