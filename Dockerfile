FROM golang:1.20.1-alpine3.17 AS build
ARG REFLEX_VERSION=v0.3.1
WORKDIR /src
RUN go install github.com/cespare/reflex@${REFLEX_VERSION}
COPY go.mod go.sum ./
RUN go mod download -x
COPY . .
RUN go build -o /app/hello-db -ldflags "-s -w" .

FROM alpine:3.17
WORKDIR /app
COPY --from=build /app/hello-db .
USER guest
ENTRYPOINT ["/app/hello-db"]
