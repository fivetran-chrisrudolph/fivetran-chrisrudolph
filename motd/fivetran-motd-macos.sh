#!/bin/bash

# Fivetran System Info Display (macOS)
# Colors
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get system information
HOSTNAME=$(hostname)
OS=$(sw_vers -productName)" "$(sw_vers -productVersion)
KERNEL=$(uname -r)
UPTIME=$(uptime | sed 's/.*up //' | sed 's/,  *[0-9]* user.*//' | xargs)
CPU_MODEL=$(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "Unknown")
CPU_CORES=$(sysctl -n hw.ncpu 2>/dev/null || echo "Unknown")

TOTAL_MEM_BYTES=$(sysctl -n hw.memsize 2>/dev/null || echo 0)
TOTAL_RAM=$(echo "$TOTAL_MEM_BYTES" | awk '{printf "%.1fGi", $1/1073741824}')
PAGE_SIZE=$(vm_stat 2>/dev/null | awk '/page size/ {print $8}')
PAGES_ACTIVE=$(vm_stat 2>/dev/null | awk '/^Pages active/ {gsub(/\./, "", $3); print $3+0}')
PAGES_WIRED=$(vm_stat 2>/dev/null | awk '/^Pages wired down/ {gsub(/\./, "", $4); print $4+0}')
USED_RAM=$(echo "$PAGES_ACTIVE $PAGES_WIRED $PAGE_SIZE" | awk '{printf "%.1fGi", ($1+$2)*$3/1073741824}')

DISK_USAGE=$(df -k / | awk 'NR==2 {
    used = $2 - $4
    printf "%.0fGi/%.0fGi (%d%%)", used/1048576, $2/1048576, used*100/$2
}')

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
echo -e "${CYAN}╰─────────────────────────────────────────╯${NC}"
echo ""

# Fivetran Logo and Name ASCII Art
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
