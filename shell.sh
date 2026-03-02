#!/bin/bash

# ----------------------------------------
# HTTP Service Installation Script
# Installs Apache Web Server
# ----------------------------------------

echo "Checking operating system..."

# Detect OS
if [ -f /etc/debian_version ]; then
    OS="debian"
elif [ -f /etc/redhat-release ]; then
    OS="redhat"
else
    echo "Unsupported OS"
    exit 1
fi

echo "Operating System detected: $OS"

# Update packages
echo "Updating package repositories..."
if [ "$OS" == "debian" ]; then
    sudo apt update -y
elif [ "$OS" == "redhat" ]; then
    sudo yum update -y
fi

# Install Apache
echo "Installing Apache HTTP Server..."
if [ "$OS" == "debian" ]; then
    sudo apt install apache2 -y
elif [ "$OS" == "redhat" ]; then
    sudo yum install httpd -y
fi

# Start service
echo "Starting HTTP service..."
if [ "$OS" == "debian" ]; then
    sudo systemctl start apache2
    sudo systemctl enable apache2
elif [ "$OS" == "redhat" ]; then
    sudo systemctl start httpd
    sudo systemctl enable httpd
fi

# Check status
echo "Checking service status..."
if [ "$OS" == "debian" ]; then
    sudo systemctl status apache2
elif [ "$OS" == "redhat" ]; then
    sudo systemctl status httpd
fi

echo "----------------------------------------"
echo "Apache HTTP Server Installed Successfully!"
echo "Access your server using: http://<your-server-ip>"
echo "----------------------------------------"
