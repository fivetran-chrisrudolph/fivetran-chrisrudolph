# Fivetran Login Banner

Fivetran-branded login banner displaying real-time system information. Available for Linux and macOS.

## Files

| File | Platform |
|---|---|
| `fivetran-motd-linux.sh` | Linux (all distros) |
| `fivetran-motd-macos.sh` | macOS |

---

## Linux Installation

Copy the script to `/etc/profile.d/` and make it executable:

```bash
sudo cp fivetran-motd-linux.sh /etc/profile.d/fivetran-motd.sh
sudo chmod +x /etc/profile.d/fivetran-motd.sh
```

Takes effect on the next login (no reboot required). To test immediately:

```bash
bash /etc/profile.d/fivetran-motd.sh
```

**How it works:** Every file in `/etc/profile.d/` is automatically sourced by bash for every interactive login shell (e.g. SSH). The script runs, prints the banner, and control returns to the shell before the prompt appears.

---

## macOS Installation

Add the following line to `~/.zshrc`:

```bash
echo '[ -f "$HOME/git/motd/fivetran-motd-macos.sh" ] && bash "$HOME/git/motd/fivetran-motd-macos.sh"' >> ~/.zshrc
```

> **Note:** Use `bash` not `source`. macOS defaults to zsh, but the script is written in bash. Using `source` causes zsh to parse it directly and will produce parse errors.

Takes effect on the next new terminal window. To test immediately:

```bash
bash ~/git/motd/fivetran-motd-macos.sh
```

---

## What Each Version Displays

### Linux
- Hostname, OS, Kernel, Uptime
- CPU model, core count, memory usage, disk usage
- Docker status (running/installed/not installed) + version + container count
- Podman status + version + container count

### macOS
- Hostname, OS, Kernel, Uptime
- CPU model, core count, memory usage, disk usage

---

## How System Info Is Collected

### Linux
| Field | Source |
|---|---|
| Hostname | `hostname` |
| OS | `/etc/os-release` |
| Kernel | `uname -r` |
| Uptime | `uptime -p` |
| CPU | `/proc/cpuinfo` |
| Cores | `nproc` |
| Memory | `free -h` |
| Disk | `df -h /` |

### macOS
| Field | Source |
|---|---|
| Hostname | `hostname` |
| OS | `sw_vers` |
| Kernel | `uname -r` |
| Uptime | `uptime` (parsed) |
| CPU | `sysctl -n machdep.cpu.brand_string` |
| Cores | `sysctl -n hw.ncpu` |
| Memory | `sysctl` + `vm_stat` (active + wired pages) |
| Disk | `df -k /` — Total minus Available (reflects full APFS container) |
