#!/bin/bash

# Fivetran System Info Display
# Colors
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get system information
HOSTNAME=$(hostname)
OS=$(cat /etc/os-release | grep "^PRETTY_NAME" | cut -d'"' -f2)
KERNEL=$(uname -r)
UPTIME=$(uptime -p | sed 's/up //')
CPU_MODEL=$(grep "model name" /proc/cpuinfo | head -1 | cut -d':' -f2 | xargs)
CPU_CORES=$(nproc)
TOTAL_RAM=$(free -h | awk '/^Mem:/ {print $2}')
USED_RAM=$(free -h | awk '/^Mem:/ {print $3}')
DISK_USAGE=$(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')

# Check Docker status
if command -v docker &> /dev/null; then
    if docker info &> /dev/null; then
        DOCKER_STATUS="${GREEN}Running${NC}"
        DOCKER_VERSION=$(docker --version | awk '{print $3}' | tr -d ',')
        DOCKER_CONTAINERS=$(docker ps -q 2>/dev/null | wc -l)
    else
        DOCKER_STATUS="${YELLOW}Installed (not running)${NC}"
        DOCKER_VERSION=$(docker --version | awk '{print $3}' | tr -d ',')
        DOCKER_CONTAINERS="0"
    fi
else
    DOCKER_STATUS="${NC}Not installed${NC}"
    DOCKER_VERSION="N/A"
    DOCKER_CONTAINERS="0"
fi

# Check Podman status
if command -v podman &> /dev/null; then
    PODMAN_STATUS="${GREEN}Installed${NC}"
    PODMAN_VERSION=$(podman --version | awk '{print $3}')
    PODMAN_CONTAINERS=$(podman ps -q 2>/dev/null | wc -l)
else
    PODMAN_STATUS="${NC}Not installed${NC}"
    PODMAN_VERSION="N/A"
    PODMAN_CONTAINERS="0"
fi

# Fivetran Logo and Name ASCII Art (side by side)
echo -e "${BLUE}"
cat << "EOF"
  \\\  \\\  \\\
   \\\  \\\  \\\
    \\\  \\\  \\\
     \\\  \\\
      \\\  \\\      FFFFFFF iii                   tt
       \\\  \\\     FF          vv      vv         tt
   \\\  \\\         FFFFFFF iii  vv    vv    eee  ttttt  rr rrr  aa aa  nn nnn
    \\\  \\\        FF      iii   vv  vv   ee   ee  tt   rrr    aa  aaa nnn  nn
     \\\  \\\       FF      iii    vvvv    eeeeeee  tt   rr     aaaaaaa nn   nn
 \\\  \\\  \\\      FF      iii     vv     ee       ttt  rr     aa   aa nn   nn
  \\\  \\\  \\\                              eee
   \\\  \\\  \\\

EOF
echo -e "${NC}"
echo ""

# System Information
echo -e "${CYAN}╭─────────────────────────────────────────╮${NC}"
echo -e "${CYAN}│${NC} ${GREEN}System Information${NC}                   ${CYAN}│${NC}"
echo -e "${CYAN}├─────────────────────────────────────────┤${NC}"
echo -e "${CYAN}│${NC} ${YELLOW}Hostname:${NC} $HOSTNAME"
echo -e "${CYAN}│${NC} ${YELLOW}OS:${NC} $OS"
echo -e "${CYAN}│${NC} ${YELLOW}Kernel:${NC} $KERNEL"
echo -e "${CYAN}│${NC} ${YELLOW}Uptime:${NC} $UPTIME"
echo -e "${CYAN}├─────────────────────────────────────────┤${NC}"
echo -e "${CYAN}│${NC} ${GREEN}Hardware${NC}                              ${CYAN}│${NC}"
echo -e "${CYAN}├─────────────────────────────────────────┤${NC}"
echo -e "${CYAN}│${NC} ${YELLOW}CPU:${NC} $CPU_MODEL"
echo -e "${CYAN}│${NC} ${YELLOW}Cores:${NC} $CPU_CORES"
echo -e "${CYAN}│${NC} ${YELLOW}Memory:${NC} $USED_RAM / $TOTAL_RAM"
echo -e "${CYAN}│${NC} ${YELLOW}Disk:${NC} $DISK_USAGE"
echo -e "${CYAN}├─────────────────────────────────────────┤${NC}"
echo -e "${CYAN}│${NC} ${GREEN}Container Runtime${NC}                    ${CYAN}│${NC}"
echo -e "${CYAN}├─────────────────────────────────────────┤${NC}"
echo -e "${CYAN}│${NC} ${YELLOW}Docker:${NC} $DOCKER_STATUS"
if [ "$DOCKER_VERSION" != "N/A" ]; then
    echo -e "${CYAN}│${NC}   ${YELLOW}Version:${NC} $DOCKER_VERSION"
    echo -e "${CYAN}│${NC}   ${YELLOW}Containers Running:${NC} $DOCKER_CONTAINERS"
fi
echo -e "${CYAN}│${NC} ${YELLOW}Podman:${NC} $PODMAN_STATUS"
if [ "$PODMAN_VERSION" != "N/A" ]; then
    echo -e "${CYAN}│${NC}   ${YELLOW}Version:${NC} $PODMAN_VERSION"
    echo -e "${CYAN}│${NC}   ${YELLOW}Containers Running:${NC} $PODMAN_CONTAINERS"
fi
echo -e "${CYAN}╰─────────────────────────────────────────╯${NC}"
echo ""
