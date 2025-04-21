#!/bin/bash
# filepath: c:\Users\gamin\klotendocker\docker-html-environment\start.sh

# Check if an argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <path_to_html_files> [port] [memory_limit] [cpu_limit]"
  echo "Example: $0 /path/to/html 8080 512m 1"
  exit 1
fi

# Set the HTML path
HTML_PATH=$1

# Set the port (default to 8080 if not provided)
PORT=${2:-}

# Function to check if a port is free
is_port_free() {
  local port=$1
  if netstat -an | grep -q ":$port .*LISTEN"; then
    return 1  # Port is in use
  else
    return 0  # Port is free
  fi
}

# Function to find an available port
find_free_port() {
  local port=8080
  while ! is_port_free $port; do
    port=$((port + 1))
  done
  echo $port
}

# If a port is provided, check if it's free
if [ -n "$PORT" ]; then
  if ! is_port_free $PORT; then
    echo "Error: Port $PORT is already in use."
    echo "Finding a free port..."
    PORT=$(find_free_port)
    echo "Using port $PORT instead."
  fi
else
  # If no port is provided, find a free one
  echo "No port provided. Finding a free port..."
  PORT=$(find_free_port)
  echo "Using port $PORT"
fi

# Set resource limits (optional)
MEMORY_LIMIT=${3:-"512m"}  # Default to 512MB
CPU_LIMIT=${4:-"1"}        # Default to 1 CPU

# Check if the provided path exists
if [ ! -d "$HTML_PATH" ]; then
  echo "Error: Directory $HTML_PATH does not exist."
  exit 1
fi

# Copy the HTML files to the static directory
echo "Copying HTML files from $HTML_PATH to ./static..."
mkdir -p ./static
cp -r "$HTML_PATH"/* ./static/

# Build the Docker image
echo "Building the Docker image..."
docker build -t docker-html-environment .

# Run the Docker container with resource limits and port mapping
echo "Running the Docker container on port $PORT with memory limit $MEMORY_LIMIT and CPU limit $CPU_LIMIT..."
CONTAINER_ID=$(docker run -d -p "$PORT:80" --memory="$MEMORY_LIMIT" --cpus="$CPU_LIMIT" docker-html-environment)

# Verify the container is running
if [ "$(docker ps -q -f id=$CONTAINER_ID)" ]; then
  echo "The application is now running at http://localhost:$PORT"
else
  echo "Error: Failed to start the Docker container."
  exit 1
fi