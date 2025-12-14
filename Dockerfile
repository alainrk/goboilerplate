# Build stage
FROM golang:1.24-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git make

# Set working directory
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags="-w -s" \
    -o main \
    ./cmd/main/main.go

# Final stage
FROM alpine:latest

# Install ca-certificates for HTTPS
RUN apk --no-cache add ca-certificates tzdata

# Create non-root user
RUN addgroup -g 1000 -S main && \
    adduser -u 1000 -S main -G main

# Set working directory
WORKDIR /app

# Copy binaries from builder
COPY --from=builder /app/main /app/main

# Change ownership
RUN chown -R main:main /app

# Switch to non-root user
USER main

# Expose ports
EXPOSE 8080 8081

# Set entrypoint (default to bot, can be overridden)
ENTRYPOINT ["/app/main"]
