FROM golang:1.23-alpine3.20 AS build
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download -x
COPY . .
RUN go build -o /app/hello-db -ldflags "-s -w" .

FROM alpine:3.20
WORKDIR /app
COPY --from=build /app/hello-db .
USER guest
ENTRYPOINT ["/app/hello-db"]
