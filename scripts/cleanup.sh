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
echo -e "${BLUE}  Angular Symfony Boilerplate Cleanup${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

cd "$PROJECT_ROOT"

# Check for --all flag
CLEAN_ALL=false
if [ "$1" == "--all" ]; then
    CLEAN_ALL=true
    echo -e "${YELLOW}Full cleanup mode (including .env and generated files)${NC}"
else
    echo -e "${YELLOW}Docker cleanup mode (use --all to also remove .env and keys)${NC}"
fi
echo ""

# Step 1: Stop and remove containers, images, volumes
echo -e "${YELLOW}[1/3] Stopping and removing Docker resources...${NC}"
docker compose down --rmi all -v 2>/dev/null
echo -e "${GREEN}✓ Docker containers, images, and volumes removed${NC}"

# Step 2: Remove node_modules and vendor (optional with --all)
if [ "$CLEAN_ALL" == true ]; then
    echo ""
    echo -e "${YELLOW}[2/3] Removing dependencies...${NC}"
    
    # Remove API vendor
    if [ -d "application/api/vendor" ]; then
        rm -rf application/api/vendor
        echo -e "${GREEN}✓ Removed application/api/vendor${NC}"
    fi
    
    # Remove frontend node_modules
    if [ -d "application/frontend/node_modules" ]; then
        rm -rf application/frontend/node_modules
        echo -e "${GREEN}✓ Removed application/frontend/node_modules${NC}"
    fi
    
    # Remove root node_modules
    if [ -d "node_modules" ]; then
        rm -rf node_modules
        echo -e "${GREEN}✓ Removed node_modules${NC}"
    fi
    
    # Remove pnpm store
    if [ -d "application/.pnpm-store" ]; then
        rm -rf application/.pnpm-store
        echo -e "${GREEN}✓ Removed .pnpm-store${NC}"
    fi
else
    echo ""
    echo -e "${YELLOW}[2/3] Skipping dependency removal (use --all to include)${NC}"
fi

# Step 3: Remove generated files (optional with --all)
if [ "$CLEAN_ALL" == true ]; then
    echo ""
    echo -e "${YELLOW}[3/3] Removing generated files...${NC}"
    
    # Remove .env
    if [ -f "application/api/.env" ]; then
        rm -f application/api/.env
        echo -e "${GREEN}✓ Removed application/api/.env${NC}"
    fi
    
    # Remove JWT keys
    if [ -f "application/api/config/jwt/private.pem" ]; then
        rm -f application/api/config/jwt/private.pem
        rm -f application/api/config/jwt/public.pem
        echo -e "${GREEN}✓ Removed JWT keys${NC}"
    fi
    
    # Remove composer.lock
    if [ -f "application/api/composer.lock" ]; then
        rm -f application/api/composer.lock
        echo -e "${GREEN}✓ Removed composer.lock${NC}"
    fi
    
    # Remove symfony.lock
    if [ -f "application/api/symfony.lock" ]; then
        rm -f application/api/symfony.lock
        echo -e "${GREEN}✓ Removed symfony.lock${NC}"
    fi
    
    # Remove pnpm-lock.yaml
    if [ -f "pnpm-lock.yaml" ]; then
        rm -f pnpm-lock.yaml
        echo -e "${GREEN}✓ Removed pnpm-lock.yaml${NC}"
    fi
    
    # Remove frontend dist
    if [ -d "application/frontend/dist" ]; then
        rm -rf application/frontend/dist
        echo -e "${GREEN}✓ Removed frontend dist${NC}"
    fi
    
    # Remove var folder
    if [ -d "application/api/var" ]; then
        rm -rf application/api/var
        echo -e "${GREEN}✓ Removed api var folder${NC}"
    fi
else
    echo ""
    echo -e "${YELLOW}[3/3] Skipping generated files removal (use --all to include)${NC}"
fi

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}  Cleanup Complete! 🧹${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

if [ "$CLEAN_ALL" == true ]; then
    echo -e "  Project reset to initial state."
    echo -e "  Run ${YELLOW}pnpm run setup${NC} to set up again."
else
    echo -e "  Docker resources cleaned."
    echo -e "  Run ${YELLOW}pnpm run setup${NC} to rebuild and start."
fi
echo ""

