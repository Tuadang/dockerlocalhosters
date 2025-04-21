# Docker HTML Environment

This project sets up a Docker environment to serve static HTML pages using a web server.

## Project Structure

```
docker-html-environment
├── Dockerfile
├── start.sh
├── static
│   ├── index.html
│   └── styles.css
└── README.md
```

## Getting Started

Follow the instructions below to build and run the Docker environment.

### Prerequisites

- Docker installed on your machine.
- A Bash environment (e.g., Git Bash, WSL, or Cygwin) if running on Windows.

### Building the Docker Image

To build the Docker image, run the following command in the project directory:


```
docker build -t docker-html-environment .
```

### Running the Docker Container

You can use the `start.sh` script to build and run the Docker container. The script supports dynamic port assignment and resource allocation.

#### Basic Usage
Run the script with the path to your HTML files:

```
./start.sh /path/to/html
```

#### Custom Port and Resource Limits
You can specify a custom port, memory limit, and CPU limit:

```
start.sh /path/to/html <port> <memory_limit> <cpu_limit>
```
Example:

```
start.sh /path/to/html 8081 256m 0.5
```

- `<port>`: The port to map to the container's port 80. If the specified port is in use, the script will find a free port automatically.
- `<memory_limit>`: The maximum memory allocated to the container (e.g., `256m` for 256MB).
- `<cpu_limit>`: The maximum CPU cores allocated to the container (e.g., `0.5` for half a core).

### Accessing the Application

Once the container is running, you can access the static HTML page by navigating to `http://localhost:<port>` in your web browser. Replace `<port>` with the port assigned by the script.

### Stopping the Container

To stop the running container, you can use the following command:

```
docker ps <container_id>
```

Replace `<container_id>` with the actual ID of the running container.

## Scalability Features

The `start.sh` script supports the following scalability options:

1. **Custom Port Mapping**:
   - Specify a custom port to avoid conflicts when running multiple containers.
   - If the specified port is in use, the script will automatically find a free port.
   - Example: `./start.sh /path/to/html 8081`

2. **Dynamic Port Assignment**:
   - If no port is specified, or if the specified port is in use, the script will dynamically find and assign a free port.

3. **Resource Allocation**:
   - Limit memory and CPU usage for each container.
   - Example: `./start.sh /path/to/html 8081 256m 0.5`
     - `256m`: Limits memory to 256MB.
     - `0.5`: Limits CPU usage to half a core.

4. **Running Multiple Containers**:
   - Use unique ports for each container to host multiple applications simultaneously.
   - Example:
     ```bash
     ./start.sh /path/to/html1 8081
     ./start.sh /path/to/html2 8082
     ```

5. **Monitoring**:
   - Use `docker stats` to monitor resource usage for running containers.

## Notes for Windows Users

- Use a Bash environment (e.g., Git Bash, WSL, or Cygwin) to run the `start.sh` script.
- Ensure Docker Desktop is running before executing the script.
- Use Unix-style paths for the HTML directory (e.g., `/c/Users/username/path/to/html`).