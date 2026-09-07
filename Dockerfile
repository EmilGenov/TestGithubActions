# --- Build stage ---
FROM golang:1.22-alpine AS builder

WORKDIR /src

# Cache module downloads separately from source changes
COPY go.mod ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /out/server ./...

# --- Runtime stage ---
FROM gcr.io/distroless/static-debian12

COPY --from=builder /out/server /server

EXPOSE 8080
ENTRYPOINT ["/server"]