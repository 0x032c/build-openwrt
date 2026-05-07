#!/usr/bin/env bash

echo "=============================================================================="
echo "Freeing up disk space on CI system"
echo "=============================================================================="

echo "Listing 100 largest packages"
dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -n | tail -n 100
df -h

echo "Removing large packages"
sudo apt-get remove -y '^dotnet-.*' || true
sudo apt-get remove -y '^llvm-.*' || true
sudo apt-get remove -y 'php.*' || true
sudo apt-get remove -y '^mongodb-.*' || true
sudo apt-get remove -y '^mysql-.*' || true
sudo apt-get remove -y azure-cli google-cloud-sdk hhvm google-chrome-stable firefox powershell mono-devel libgl1-mesa-dri || true
sudo apt-get autoremove -y
sudo apt-get clean
df -h

echo "Removing large directories"
sudo rm -rf /usr/share/dotnet/
sudo rm -rf /usr/local/graalvm/
sudo rm -rf /usr/local/.ghcup/
sudo rm -rf /usr/local/share/powershell
sudo rm -rf /usr/local/share/chromium
sudo rm -rf /usr/local/lib/android
sudo rm -rf /usr/local/lib/node_modules
sudo rm -rf /opt/ghc
sudo rm -rf /swapfile

df -h
