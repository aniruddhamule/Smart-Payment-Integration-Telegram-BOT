#!/bin/bash

echo "╔══════════════════════════════════════════════════════════╗"
echo "║   SEMI-AUTOMATIC MEMBERSHIP BOT - QUICK SETUP            ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker not installed!${NC}"
    echo "Install: curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh"
    exit 1
fi

echo -e "${GREEN}✅ Docker installed${NC}"

# Check Docker Compose (Updated for modern Docker plugin syntax)
if ! docker compose version &> /dev/null; then
    echo -e "${RED}❌ Docker Compose plugin not found!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Docker Compose installed${NC}"
echo ""

# Create directories
echo -e "${YELLOW}📁 Creating directories...${NC}"
mkdir -p data logs
chmod 755 data logs
echo -e "${GREEN}✅ Directories created${NC}"
echo ""

# Check env file (Updated to match new architecture requirements)
echo -e "${YELLOW}🔐 Checking environment variables...${NC}"
if [ ! -f .env ] || grep -q "123456789:ABCdefGHIjklMNOpqr_STUvwxyz" .env; then
    echo -e "${YELLOW}⚠️ No valid configuration found. Let's set it up now!${NC}"
    echo "Please paste the following credentials (Right-click to paste in most terminals):"
    echo ""

    # Prompt the user for inputs
    read -p "1. Enter TELEGRAM_BOT_TOKEN (from @BotFather): " INPUT_BOT_TOKEN
    read -p "2. Enter MONGO_URI (Your MongoDB connection string): " INPUT_MONGO_URI
    read -p "3. Enter ADMIN_CHAT_ID (Numeric ID from @userinfobot): " INPUT_ADMIN_ID
    read -p "4. Enter ADMIN_USERNAME (e.g., @yourhandle): " INPUT_ADMIN_USERNAME

    echo ""
    echo -e "${YELLOW}Writing configuration to .env file...${NC}"

    # Write the inputs safely into the .env file
    cat <<EOF > .env
# 1. CORE SECURITY
TELEGRAM_BOT_TOKEN=$INPUT_BOT_TOKEN
MONGO_URI=$INPUT_MONGO_URI
ADMIN_CHAT_ID=$INPUT_ADMIN_ID
ADMIN_USERNAME=$INPUT_ADMIN_USERNAME

# 2. GLOBAL DISPLAY SETTINGS
BOT_NAME="Premium Membership Bot"
MERCHANT_NAME="Premium Service"
INVITE_LINK_EXPIRY_HOURS=24
EOF

    echo -e "${GREEN}✅ .env file successfully created!${NC}"
    echo ""
else
    echo -e "${GREEN}✅ Secure .env Configuration found and looks good!${NC}"
    echo ""
fi

# Build (Updated to remove hyphen)
echo -e "${YELLOW}🔨 Building Docker image...${NC}"
docker compose build

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Build failed!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Build successful${NC}"
echo ""

# Start (Updated to remove hyphen)
echo -e "${YELLOW}🚀 Starting bot...${NC}"
docker compose up -d

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to start!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Bot started!${NC}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Commands:"
echo "  docker compose logs -f    # View logs"
echo "  docker compose down       # Stop bot"
echo "  docker compose restart    # Restart bot"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${GREEN}🎉 Setup complete! Send /admin to your bot to finish configuring plans and channels.${NC}"