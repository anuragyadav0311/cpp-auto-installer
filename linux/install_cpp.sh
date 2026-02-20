#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)"
  exit 1
fi

echo "Detecting Linux distribution..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Cannot detect OS."
    exit 1
fi

if [ "$OS" = "ubuntu" ] || [ "$OS" = "debian" ]; then
    echo "Installing GCC on $OS..."
    apt update
    apt install -y build-essential gdb
elif [ "$OS" = "arch" ]; then
    echo "Installing GCC on Arch Linux..."
    pacman -Sy --noconfirm --needed base-devel gdb
else
    echo "Unsupported Linux distribution: $OS"
    exit 1
fi

echo "Verifying installation..."
gcc --version
echo "C/C++ Compiler Installed Successfully!"