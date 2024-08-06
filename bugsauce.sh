#!/bin/bash

ls -a

PORT=8080

# Function to handle HTTP requests
handle_request() {
    # Read the request line
    read -r request_line
    # Skip headers (if any) and only handle the request line
    while [ "$request_line" != "" ]; do
        read -r request_line
    done

    # Serve a simple HTML response
    echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n"
    echo "<!DOCTYPE html>"
    echo "<html><head><title>Simple HTTP Server</title></head><body>"
    echo "<h1>Welcome to the Simple HTTP Server!</h1>"
    echo "<p>This is a minimal HTTP server running in Bash using netcat.</p>"
    echo "</body></html>"
}

# Start the HTTP server
echo "Starting HTTP server on port $PORT..."
python3 -m http.server 8080
while :; do
    { echo -ne "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n$(handle_request)"; } | nc -l -p "$PORT" -q 1
done
