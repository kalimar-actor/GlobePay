#!/bin/bash

set -e

echo "🚀 Setting up GlobePay Platform..."

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check Docker
echo "${YELLOW}Checking Docker installation...${NC}"
if ! command -v docker &> /dev/null; then
  echo "${RED}Docker is not installed. Please install Docker first.${NC}"
  exit 1
fi
echo "${GREEN}✓ Docker found${NC}"

# Check Docker Compose
echo "${YELLOW}Checking Docker Compose installation...${NC}"
if ! command -v docker-compose &> /dev/null; then
  echo "${RED}Docker Compose is not installed. Please install Docker Compose first.${NC}"
  exit 1
fi
echo "${GREEN}✓ Docker Compose found${NC}"

# Setup environment
echo "${YELLOW}Setting up environment...${NC}"
if [ ! -f .env ]; then
  cp .env.example .env
  echo "${GREEN}✓ .env file created${NC}"
else
  echo "${YELLOW}⚠ .env file already exists${NC}"
fi

# Start Docker services
echo "${YELLOW}Starting Docker services...${NC}"
docker-compose up -d
echo "${GREEN}✓ Docker services started${NC}"

# Wait for services
echo "${YELLOW}Waiting for services to be ready...${NC}"
sleep 10

# Setup backend
echo "${YELLOW}Setting up backend...${NC}"
cd packages/globepay-api

if [ ! -d node_modules ]; then
  echo "${YELLOW}Installing dependencies...${NC}"
  npm install
  echo "${GREEN}✓ Dependencies installed${NC}"
fi

echo "${YELLOW}Running Prisma migrations...${NC}"
npm run prisma:migrate
echo "${GREEN}✓ Database migrated${NC}"

echo "${YELLOW}Seeding database...${NC}"
npm run seed
echo "${GREEN}✓ Database seeded${NC}"

cd ../..

echo ""
echo "${GREEN}========================================${NC}"
echo "${GREEN}✓ GlobePay setup complete!${NC}"
echo "${GREEN}========================================${NC}"
echo ""
echo "${YELLOW}Next steps:${NC}"
echo "1. Backend API: http://localhost:3000"
echo "2. Swagger Docs: http://localhost:3000/docs"
echo "3. Database UI: http://localhost:5555 (after setup)"
echo ""
echo "${YELLOW}Start backend (in new terminal):${NC}"
echo "cd packages/globepay-api && npm run start:dev"
echo ""
echo "${YELLOW}Start admin dashboard:${NC}"
echo "cd packages/globepay-admin && npm run dev"
echo ""
echo "${YELLOW}Start Flutter mobile app:${NC}"
echo "cd packages/globepay-mobile && flutter run"
echo ""
