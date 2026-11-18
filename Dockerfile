FROM golang:1.27.0 AS build
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY main.go render.go ./
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /d2-diagram-renderer .

FROM scratch
COPY --from=build /d2-diagram-renderer /d2-diagram-renderer
ENV LISTEN_ADDR=:8080
USER 10001:10001
EXPOSE 8080
ENTRYPOINT ["/d2-diagram-renderer"]
