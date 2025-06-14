# Angular Symfony Boilerplate

This project is a boilerplate for Angular and Symfony applications, set up with Docker for easy development.

## Features

- Angular 18+ frontend with standalone components
- Symfony 7+ backend with API structure
- Docker containerization for easy setup
- MySQL database

## Getting Started

### Prerequisites

- Docker and Docker Compose
- Node.js and npm
- PHP 8.3+

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/angular-symfony-boilerplate.git
cd angular-symfony-boilerplate
```

2. Start the Docker containers (Symfony backend and MySQL):
```bash
docker-compose up -d
```

3. Access the application:
   - Frontend: http://localhost:4200
   - Backend API: http://localhost:80/api

### Development Workflow

#### Backend (Symfony)
The Symfony application runs in Docker and is accessible at http://localhost:80

To access the Docker container:
```bash
docker exec -it angular-symfony-apache bash
cd /var/www/html
composer install
```

#### Frontend (Angular)
The Angular application runs locally for better development experience:

1. Navigate to the Angular app directory:
```bash
cd application/app
```

2. Install dependencies (if not already done):
```bash
npm install
```

3. Start the development server:
```bash
# For local development only:
npm start

# OR for network access:
ng serve --host 0.0.0.0
```

The development server will start with hot-reload enabled. The Angular app will be available at http://localhost:4200.

Note: Use `ng serve --host 0.0.0.0` if you need to access the application from other devices on your network.

### Stopping the Application

1. Stop the Angular development server:
   - Press `Ctrl + C` in the terminal where Angular is running

2. Stop the Docker containers:
```bash
docker-compose down
```

## Project Structure

- `/application/app` - Angular application
- `/application/src` - Symfony application source files
- `/docker-apache` - Apache configuration
- `/docker-mysql` - MySQL configuration

## License

This project is licensed under the MIT License - see the LICENSE file for details.
