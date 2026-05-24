#!/bin/bash
set -e

LOGFILE="$HOME/.update.log"
exec > >(tee -a "$LOGFILE") 2>&1
echo "=== Update started: $(date) ==="

if command -v nordvpn &> /dev/null; then
  read -p "Do you want to connect to NordVPN? (y/n): " VPN_CHOICE
  case "$VPN_CHOICE" in
    y|Y)
      echo "Connecting to NordVPN..."
      nordvpn connect
      ;;
    n|N)
      echo "Skipping NordVPN connection."
      ;;
    *)
      echo "Invalid choice. Please enter y or n."
      exit 1
      ;;
  esac
else
  echo "NordVPN not installed, skipping."
fi

echo "--- APT ---"
sudo apt-get update -y
sudo apt-get full-upgrade -y
sudo apt-get autoremove -y
sudo apt-get clean

if command -v snap &> /dev/null; then
  echo "--- Snap ---"
  sudo snap refresh
fi

if command -v flatpak &> /dev/null; then
  echo "--- Flatpak ---"
  flatpak update -y
fi

echo "=== Update finished: $(date) ==="

if [ -f /var/run/reboot-required ]; then
  echo "A reboot is required."
  read -p "Reboot now? (y/n): " REBOOT_CHOICE
  case "$REBOOT_CHOICE" in
    y|Y) sudo reboot ;;
    *) echo "Reboot skipped. Remember to reboot later." ;;
  esac
fi
