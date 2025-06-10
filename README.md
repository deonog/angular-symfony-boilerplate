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

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/angular-symfony-boilerplate.git
cd angular-symfony-boilerplate
```

2. Start the Docker containers:
```bash
docker-compose up -d
```

3. Access the application:
   - Frontend: http://localhost:4200
   - Backend API: http://localhost:80/api

## Project Structure

- `/application/app` - Angular application
- `/application/src` - Symfony application source files
- `/docker-apache` - Apache configuration
- `/docker-mysql` - MySQL configuration

## Development

### Frontend (Angular)

The Angular application is located in the `/application/app` directory.

```bash
docker exec -it angular-symfony-apache bash
cd /var/www/html/app
npm install
npm start
```

### Backend (Symfony)

The Symfony application is located in the `/application/src` directory.

```bash
docker exec -it angular-symfony-apache bash
cd /var/www/html
composer install
```

## License

This project is licensed under the MIT License - see the LICENSE file for details. # angular-symfony-boilerplate
