# Angular Symfony Monorepo Boilerplate

A modern monorepo boilerplate with Angular 19 frontend and Symfony 7.1 backend API, fully containerized with Docker.

## 📑 Table of Contents

- [Architecture](#-architecture)
- [Project Structure](#-project-structure)
- [Complete Setup Guide](#-complete-setup-guide)
  - [Prerequisites](#prerequisites)
  - [Quick Setup (Recommended)](#quick-setup-recommended-)
  - [Manual Setup (Alternative)](#manual-setup-alternative)
  - [Access the Application](#access-the-application)
- [Available Commands](#-available-commands)
- [Development Workflow](#-development-workflow)
- [Configuration Reference](#-configuration-reference)
- [Updating Dependencies](#-updating-dependencies)
- [Troubleshooting](#-troubleshooting)
- [Known Issues](#-known-issues)
- [Security Notes](#-security-notes)
- [License](#-license)

---

## 🚀 Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Docker Compose                        │
├─────────────────┬─────────────────┬─────────────────────────┤
│    Frontend     │      API        │        Database         │
│   (Angular)     │   (Symfony)     │        (MySQL)          │
│                 │                 │                         │
│  localhost:4200 │  localhost:90   │     localhost:3307      │
│   Node.js 20    │  PHP 8.3/Nginx  │        MySQL 8          │
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
│       ├── .env.example   # Environment template
│       └── composer.json
├── docker-nginx/          # PHP-FPM/Nginx Docker config
├── docker-mysql/          # MySQL Docker config
├── compose.yml
├── package.json           # Root with pnpm workspaces
└── pnpm-workspace.yaml
```

---

## 📋 Complete Setup Guide

### Prerequisites

Before starting, ensure you have installed:

- **Docker Desktop** (includes Docker Compose)
- **Node.js** >= 20.0.0
- **pnpm** >= 9.0.0

To install pnpm:
```bash
corepack enable
corepack prepare pnpm@9.15.0 --activate
```

---

### Quick Setup (Recommended) ⚡

Run the automated setup script that handles everything:

```bash
git clone https://github.com/yourusername/angular-symfony-boilerplate.git
cd angular-symfony-boilerplate
pnpm run setup
```

This script will:
1. ✅ Check prerequisites (Docker, pnpm)
2. ✅ Create `.env` from `.env.example` with auto-generated secrets
3. ✅ Build Docker images (skips if already built)
4. ✅ Start all containers
5. ✅ Generate JWT keys (skips if already exist)
6. ✅ Verify everything is running

**Running again?** The script is idempotent - it skips completed steps.

**Force rebuild?** Use `pnpm run setup:rebuild`

---

### Manual Setup (Alternative)

<details>
<summary>Click to expand manual setup steps</summary>

#### Step 1: Clone the Repository

```bash
git clone https://github.com/yourusername/angular-symfony-boilerplate.git
cd angular-symfony-boilerplate
```

#### Step 2: Configure Environment Variables

##### 2.1 Copy the environment template

```bash
cp application/api/.env.example application/api/.env
```

##### 2.2 Generate APP_SECRET

Generate a secure random string for Symfony:

```bash
# On macOS/Linux
openssl rand -hex 16

# Or using PHP (if installed locally)
php -r "echo bin2hex(random_bytes(16)) . PHP_EOL;"
```

Copy the output and update `application/api/.env`:

```env
APP_SECRET=your_generated_32_character_string_here
```

##### 2.3 Set JWT_PASSPHRASE

Generate a passphrase for JWT authentication:

```bash
openssl rand -base64 32
```

Update `application/api/.env`:

```env
JWT_PASSPHRASE=your_generated_passphrase_here
```

Your `.env` file should now look like:

```env
APP_ENV=dev
APP_SECRET=a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6
DATABASE_URL="mysql://app:app@mysql:3306/app?serverVersion=8.0&charset=utf8mb4"
JWT_SECRET_KEY=%kernel.project_dir%/config/jwt/private.pem
JWT_PUBLIC_KEY=%kernel.project_dir%/config/jwt/public.pem
JWT_PASSPHRASE=your_generated_passphrase_here
```

#### Step 3: Build and Start Docker

```bash
# Build all Docker images (first time or after Dockerfile changes)
pnpm run docker:build

# Start all services
pnpm run dev
```

Wait for all containers to start. You can check the logs:

```bash
pnpm run dev:logs
```

#### Step 4: Generate JWT Keys

After Docker is running, generate the JWT keypair inside the container:

```bash
docker exec angular-symfony-nginx php bin/console lexik:jwt:generate-keypair
```

This creates:
- `application/api/config/jwt/private.pem`
- `application/api/config/jwt/public.pem`

> **Note:** These files are gitignored and must be generated on each new setup.

#### Step 5: Run Database Migrations (Optional)

If your project has database migrations:

```bash
pnpm run api:migrate
```

</details>

---

### Access the Application

| Service | URL | Description |
|---------|-----|-------------|
| **Frontend** | http://localhost:4200 | Angular dev server (hot-reload) |
| **API** | http://localhost:90 | Symfony backend |
| **MySQL** | localhost:3307 | Database (user: `app`, pass: `app`) |

---

## ✅ Setup Complete!

Your development environment is now ready. The Angular frontend will hot-reload on code changes, and the Symfony API is accessible for backend development.

---

## 📜 Available Commands

| Command | Description |
|---------|-------------|
| `pnpm run setup` | **One-command setup** (idempotent) |
| `pnpm run setup:rebuild` | Setup with forced Docker rebuild |
| `pnpm run dev` | Start all Docker services |
| `pnpm run dev:logs` | View Docker logs |
| `pnpm run dev:stop` | Stop all services |
| `pnpm run docker:build` | Rebuild images (no cache) |
| `pnpm run docker:clean` | Remove all containers, images & volumes |
| `pnpm run cleanup` | Clean Docker resources |
| `pnpm run cleanup:all` | **Full reset** (removes .env, keys, node_modules) |
| `pnpm run api:cache:clear` | Clear Symfony cache |
| `pnpm run api:migrate` | Run database migrations |

---

## 🏗️ Development Workflow

### Backend (Symfony)

```bash
# Access container shell
docker exec -it angular-symfony-nginx bash

# Inside container:
cd /var/www/html/api

# Create a controller
php bin/console make:controller ApiController

# Create an entity
php bin/console make:entity User

# Run migrations
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

### Local Frontend Development (without Docker)

```bash
cd application/frontend
pnpm install
pnpm start
```

---

## 🔧 Configuration Reference

### API Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `APP_ENV` | Environment mode | `dev` or `prod` |
| `APP_SECRET` | Symfony secret key | 32-char hex string |
| `DATABASE_URL` | Database connection | `mysql://user:pass@host:port/db` |
| `JWT_PASSPHRASE` | JWT key passphrase | Random string |

### Frontend Environment

Edit `application/frontend/src/environments/environment.ts`:

```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:90/api'
};
```

---

## 📦 Updating Dependencies

### Frontend (Angular)

```bash
cd application/frontend
pnpm ng update @angular/core @angular/cli
pnpm update
```

### Backend (Symfony)

```bash
docker exec -it angular-symfony-nginx bash
cd /var/www/html/api
composer update
```

---

## 🧹 Troubleshooting

### Reset Everything

```bash
# Stop and remove all containers, images, and volumes
pnpm run docker:clean

# Rebuild from scratch
pnpm run docker:build
pnpm run dev
```

### Permission Issues

```bash
# Fix file permissions
sudo chown -R $(whoami):$(whoami) application/
```

### Clear Symfony Cache

```bash
pnpm run api:cache:clear
```

---

## ⚠️ Known Issues

### Symfony Security Advisory (Temporary)

This boilerplate currently includes a temporary workaround for Symfony security advisories affecting `symfony/http-foundation`. The following advisories are ignored in `composer.json`:

```json
"audit": {
    "ignore": [
        "PKSA-365x-2zjk-pt47",
        "PKSA-b35n-565h-rs4q"
    ]
}
```

**Action Required:** Once Symfony releases patched versions, you should:

1. Remove the `audit.ignore` section from `application/api/composer.json`
2. Run `composer update` to get the patched packages
3. Check [Packagist Security Advisories](https://packagist.org/security-advisories/) for updates

---

## 🔒 Security Notes

- **Never commit `.env` files** - They contain secrets
- **Generate unique secrets** for each environment
- **JWT keys are gitignored** - Generate them on each setup
- Change default database password in production
- **Review security advisories** regularly and update dependencies

---

## 📄 License

MIT License
