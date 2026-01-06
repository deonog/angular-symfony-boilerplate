#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Angular Symfony Boilerplate Setup${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

cd "$PROJECT_ROOT"

# Step 1: Check prerequisites
echo -e "${YELLOW}[1/6] Checking prerequisites...${NC}"

if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

if ! command -v pnpm &> /dev/null; then
    echo -e "${RED}❌ pnpm is not installed. Run: corepack enable && corepack prepare pnpm@9.15.0 --activate${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Prerequisites OK${NC}"

# Step 2: Copy .env.example to .env
echo ""
echo -e "${YELLOW}[2/6] Setting up environment files...${NC}"

if [ -f "application/api/.env" ]; then
    echo -e "${GREEN}✓ API .env already exists, skipping${NC}"
else
    if [ -f "application/api/.env.example" ]; then
        cp application/api/.env.example application/api/.env
        
        # Generate APP_SECRET
        APP_SECRET=$(openssl rand -hex 16)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/<GENERATE_WITH_php_bin_console_secrets_generate-keys>/$APP_SECRET/" application/api/.env
        else
            sed -i "s/<GENERATE_WITH_php_bin_console_secrets_generate-keys>/$APP_SECRET/" application/api/.env
        fi
        
        # Generate JWT_PASSPHRASE
        JWT_PASS=$(openssl rand -base64 32 | tr -d '\n')
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s|<YOUR_JWT_PASSPHRASE>|$JWT_PASS|" application/api/.env
        else
            sed -i "s|<YOUR_JWT_PASSPHRASE>|$JWT_PASS|" application/api/.env
        fi
        
        # Add CORS_ALLOW_ORIGIN if not present
        if ! grep -q "CORS_ALLOW_ORIGIN" application/api/.env; then
            echo "" >> application/api/.env
            echo "###> nelmio/cors-bundle ###" >> application/api/.env
            echo "CORS_ALLOW_ORIGIN='^https?://(localhost|127\\.0\\.0\\.1)(:[0-9]+)?\$'" >> application/api/.env
            echo "###< nelmio/cors-bundle ###" >> application/api/.env
        fi
        
        echo -e "${GREEN}✓ Created .env with generated secrets${NC}"
    else
        echo -e "${RED}❌ .env.example not found${NC}"
        exit 1
    fi
fi

# Step 3: Build Docker images
echo ""
echo -e "${YELLOW}[3/6] Building Docker images...${NC}"

# Check if images exist
if docker images | grep -q "angular-symfony-boilerplate-nginx"; then
    echo -e "${GREEN}✓ Docker images already built, skipping (use --rebuild to force)${NC}"
    if [ "$1" == "--rebuild" ]; then
        echo -e "${YELLOW}  Rebuilding due to --rebuild flag...${NC}"
        docker compose build --no-cache
    fi
else
    echo -e "${BLUE}  Building images (this may take a few minutes)...${NC}"
    docker compose build --no-cache
    echo -e "${GREEN}✓ Docker images built${NC}"
fi

# Step 4: Start Docker containers
echo ""
echo -e "${YELLOW}[4/6] Starting Docker containers...${NC}"

if docker ps | grep -q "angular-symfony-nginx"; then
    echo -e "${GREEN}✓ Containers already running${NC}"
else
    docker compose up -d
    echo -e "${BLUE}  Waiting for containers to be ready...${NC}"
    sleep 5
    echo -e "${GREEN}✓ Containers started${NC}"
fi

# Step 5: Generate JWT keys
echo ""
echo -e "${YELLOW}[5/6] Setting up JWT keys...${NC}"

if [ -f "application/api/config/jwt/private.pem" ]; then
    echo -e "${GREEN}✓ JWT keys already exist, skipping${NC}"
else
    echo -e "${BLUE}  Generating JWT keypair...${NC}"
    
    # Create jwt directory if it doesn't exist
    mkdir -p application/api/config/jwt
    
    # Get JWT passphrase from .env
    JWT_PASS=$(grep JWT_PASSPHRASE application/api/.env | cut -d '=' -f2)
    
    # Try Symfony command first, fallback to openssl
    if docker exec angular-symfony-nginx php bin/console lexik:jwt:generate-keypair --skip-if-exists 2>/dev/null; then
        echo -e "${GREEN}✓ JWT keys generated via Symfony${NC}"
    elif docker exec angular-symfony-nginx php bin/console lexik:jwt:generate-keypair 2>/dev/null; then
        echo -e "${GREEN}✓ JWT keys generated via Symfony${NC}"
    else
        # Fallback: Generate keys using openssl locally
        echo -e "${BLUE}  Using openssl fallback...${NC}"
        openssl genpkey -out application/api/config/jwt/private.pem -aes256 -algorithm rsa -pkeyopt rsa_keygen_bits:4096 -pass pass:"$JWT_PASS" 2>/dev/null
        openssl pkey -in application/api/config/jwt/private.pem -out application/api/config/jwt/public.pem -pubout -passin pass:"$JWT_PASS" 2>/dev/null
        
        if [ -f "application/api/config/jwt/private.pem" ]; then
            echo -e "${GREEN}✓ JWT keys generated via openssl${NC}"
        else
            echo -e "${YELLOW}  ⚠ JWT key generation failed. Run manually:${NC}"
            echo -e "${YELLOW}    docker exec angular-symfony-nginx php bin/console lexik:jwt:generate-keypair${NC}"
        fi
    fi
fi

# Step 6: Final checks
echo ""
echo -e "${YELLOW}[6/6] Verifying setup...${NC}"

# Wait a bit more for services to be fully ready
sleep 3

# Check API
if curl -s http://localhost:90/ | grep -q "Symfony"; then
    echo -e "${GREEN}✓ Symfony API is running at http://localhost:90${NC}"
else
    echo -e "${YELLOW}⚠ Symfony API not responding yet (may still be starting)${NC}"
fi

# Check Frontend
if curl -s http://localhost:4200/ | grep -q "Angular"; then
    echo -e "${GREEN}✓ Angular Frontend is running at http://localhost:4200${NC}"
else
    echo -e "${YELLOW}⚠ Angular Frontend not responding yet (may still be starting)${NC}"
fi

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}  Setup Complete! 🎉${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "  Frontend: ${BLUE}http://localhost:4200${NC}"
echo -e "  API:      ${BLUE}http://localhost:90${NC}"
echo -e "  MySQL:    ${BLUE}localhost:3307${NC} (user: app, pass: app)"
echo ""
echo -e "  View logs:  ${YELLOW}pnpm run dev:logs${NC}"
echo -e "  Stop:       ${YELLOW}pnpm run dev:stop${NC}"
echo ""

