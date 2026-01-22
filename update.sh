#!/bin/bash
set -e
nordvpn connect
sudo apt-get update -y
sudo apt-get install -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get full-upgrade -y
sudo apt-get autoremove -y
