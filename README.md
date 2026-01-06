# Angular Symfony Monorepo Boilerplate

A modern monorepo boilerplate with Angular 19 frontend and Symfony 7.1 backend API.

## 🚀 Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Docker Compose                        │
├─────────────────┬─────────────────┬─────────────────────────┤
│    Frontend     │      API        │        Database         │
│   (Angular)     │   (Symfony)     │        (MySQL)          │
│                 │                 │                         │
│  localhost:4200 │  localhost:90   │     localhost:3307      │
│   Node.js 20    │  PHP 8.3/Apache │        MySQL 8          │
└─────────────────┴─────────────────┴─────────────────────────┘
```

## 📁 Project Structure

```
angular-symfony-boilerplate/
├── application/
│   ├── frontend/          # Angular 19 application
│   │   ├── src/
│   │   ├── angular.json
│   │   └── package.json
│   └── api/               # Symfony 7.1 API
│       ├── src/
│       ├── config/
│       ├── public/
│       └── composer.json
├── docker-apache/         # PHP/Apache Docker config
├── docker-mysql/          # MySQL Docker config
├── compose.yml
├── package.json           # Root with pnpm workspaces
└── pnpm-workspace.yaml
```

## 🛠️ Prerequisites

- **Node.js** >= 20.0.0
- **pnpm** >= 9.0.0
- **Docker** and **Docker Compose**

## 🏁 Quick Start

### 1. Clone and Start

```bash
git clone https://github.com/yourusername/angular-symfony-boilerplate.git
cd angular-symfony-boilerplate

# Build and start all services
pnpm run docker:build
pnpm run dev
```

### 2. Access the Application

| Service | URL | Description |
|---------|-----|-------------|
| **Frontend** | http://localhost:4200 | Angular dev server (hot-reload) |
| **API** | http://localhost:90 | Symfony backend |
| **MySQL** | localhost:3307 | Database (user: app, pass: app) |

## 📜 Available Commands

| Command | Description |
|---------|-------------|
| `pnpm run dev` | Start all Docker services |
| `pnpm run dev:logs` | View Docker logs |
| `pnpm run dev:stop` | Stop all services |
| `pnpm run docker:build` | Rebuild images (no cache) |
| `pnpm run docker:clean` | Remove all containers, images & volumes |
| `pnpm run api:cache:clear` | Clear Symfony cache |
| `pnpm run api:migrate` | Run database migrations |

### Local Development (without Docker frontend)

```bash
# Run Angular locally instead of in Docker
cd application/frontend
pnpm install
pnpm start
```

## 🔧 Configuration

### Initial Setup

The `.env` files are not committed. Copy the examples on first setup:

```bash
# API
cp application/api/.env.example application/api/.env

# Frontend (optional - for custom API URL)
cp application/frontend/src/environments/environment.example.ts application/frontend/src/environments/environment.ts
```

**Note:** Docker automatically copies `.env.example` to `.env` during build if `.env` doesn't exist.

### API Environment (.env)

```env
APP_ENV=dev
APP_SECRET=your_secret_here
DATABASE_URL="mysql://app:app@mysql:3306/app?serverVersion=8.0"
```

### Frontend Environment

Configure API endpoints in `application/frontend/src/environments/`:

```typescript
// environment.ts
export const environment = {
  production: false,
  apiUrl: 'http://localhost:90/api'
};
```

## 🏗️ Development Workflow

### Backend (Symfony)

```bash
# Access container shell
docker exec -it angular-symfony-apache bash

# Inside container:
cd /var/www/html/api
php bin/console make:controller ApiController
php bin/console make:entity User
php bin/console doctrine:migrations:migrate
```

### Frontend (Angular)

```bash
cd application/frontend

# Generate components
pnpm ng generate component components/MyComponent

# Generate services
pnpm ng generate service services/MyService

# Run tests
pnpm test
```

## 📦 Updating Dependencies

### Frontend

```bash
cd application/frontend
pnpm ng update @angular/core @angular/cli
pnpm update
```

### Backend

```bash
docker exec -it angular-symfony-apache bash
cd /var/www/html/api
composer update
```

## 🔒 Security

- JWT authentication pre-configured with `lexik/jwt-authentication-bundle`
- CORS configured via `nelmio/cors-bundle`
- Change default secrets before deploying to production

## 📄 License

MIT License
