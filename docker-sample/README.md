# Sample Docker Project

This is a simple Flask application containerized with Docker.

## Prerequisites

- Docker
- Docker Compose

## Running the Application

1. Navigate to the project directory:
   ```
   cd docker-sample
   ```

2. Build and run the application:
   ```
   docker-compose up --build
   ```

3. Open your browser and go to `http://localhost:5000` to see "Hello, Docker!"

## Stopping the Application

Press `Ctrl+C` in the terminal, or run:
```
docker-compose down
```