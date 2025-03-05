#!/bin/bash

# Check if Vagrant is installed
if ! command -v vagrant &> /dev/null; then
    echo "Vagrant is not installed. Please install Vagrant first."
    exit 1
fi

# Check if VirtualBox is installed
if ! command -v VBoxManage &> /dev/null; then
    echo "VirtualBox is not installed. Please install VirtualBox first."
    exit 1
fi

# Install required Vagrant plugin
vagrant plugin install vagrant-hostmanager

# Check if DO_API_TOKEN is provided
if [ -z "$1" ]; then
    echo "Please provide your DigitalOcean API token as an argument:"
    echo "./setup.sh your_digitalocean_api_token"
    exit 1
fi

# Export the DO_API_TOKEN
export DO_API_TOKEN="$1"

# Create necessary directories if they don't exist
mkdir -p .vagrant

# Start Vagrant
echo "Starting Vagrant environment..."
vagrant up

# Print status
if [ $? -eq 0 ]; then
    echo "Setup completed successfully!"
    echo "Your environment is now ready."
    echo
    echo "Access your services at:"
    echo "WordPress: http://localhost:8080"
    echo "PHPMyAdmin: http://localhost:8081"
    echo
    echo "To SSH into the VM:"
    echo "$ vagrant ssh"
else
    echo "Setup failed. Please check the error messages above."
fi 