#!/bin/bash

echo "Checking for Apple Command Line Tools..."

if xcode-select -p &> /dev/null; then
    echo "Command Line Tools are already installed."
else
    echo "Installing Apple Command Line Tools..."
    xcode-select --install
    echo "Please follow the GUI prompt to complete the installation."
    # Wait for the user to finish the GUI installation
    until xcode-select -p &> /dev/null; do
        sleep 5
    done
fi

echo "Verifying installation..."
gcc --version
echo "C/C++ Compiler Installed Successfully!"