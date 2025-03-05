#!/bin/bash

# Check if Vagrant is installed
if ! command -v vagrant &> /dev/null; then
    echo "Vagrant is not installed. Please install it first."
    exit 1
fi

# Check if VirtualBox is installed
if ! command -v VBoxManage &> /dev/null; then
    echo "VirtualBox is not installed. Please install it first."
    exit 1
fi

# Function to parse JSON without jq
parse_json() {
    local json="$1"
    local field="$2"
    echo "$json" | grep -o "\"$field\":[^,}]*" | cut -d':' -f2 | tr -d '[]" '
}

# Check if DO_API_TOKEN is provided
if [ -z "$1" ]; then
    echo "Please provide your DigitalOcean API token as an argument:"
    echo "Usage: $0 your_digitalocean_api_token"
    exit 1
fi

# Export the DO_API_TOKEN for Vagrant to use
export DO_API_TOKEN="$1"

# Create directories in goinfre
GOINFRE_PATH="/goinfre/$USER"
VAGRANT_HOME="$GOINFRE_PATH/.vagrant.d"
VBOX_PATH="$GOINFRE_PATH/VirtualBox VMs"

echo "Creating necessary directories in goinfre..."
mkdir -p "$VAGRANT_HOME"
mkdir -p "$VBOX_PATH"
mkdir -p "$VAGRANT_HOME/boxes"
mkdir -p "$VAGRANT_HOME/tmp"

# Set VirtualBox VM location
echo "Setting VirtualBox VM location..."
VBoxManage setproperty machinefolder "$VBOX_PATH"

# Clean up any existing VMs and Vagrant state
echo "Cleaning up existing VMs and Vagrant state..."
vagrant destroy -f >/dev/null 2>&1
VBoxManage list vms | grep "wordpress-ansible-docker" | cut -d'"' -f2 | xargs -I {} VBoxManage unregistervm {} --delete 2>/dev/null
rm -rf ~/.vagrant.d/boxes/*
rm -rf ~/.vagrant.d/tmp/*
rm -rf .vagrant
rm -rf "$VBOX_PATH/wordpress-ansible-docker"

# Set Vagrant environment variables
export VAGRANT_HOME="$VAGRANT_HOME"

# Register SSH key with DigitalOcean
echo "Registering SSH key with DigitalOcean..."
SSH_KEY_PATH="$HOME/.ssh/id_rsa.pub"

if [ ! -f "$SSH_KEY_PATH" ]; then
    echo "Generating new SSH key..."
    ssh-keygen -t rsa -b 4096 -f "$HOME/.ssh/id_rsa" -N ""
fi

# Verify SSH key exists and is readable
if [ ! -f "$SSH_KEY_PATH" ]; then
    echo "Error: SSH public key not found at $SSH_KEY_PATH"
    exit 1
fi

SSH_KEY=$(cat "$SSH_KEY_PATH")
if [ -z "$SSH_KEY" ]; then
    echo "Error: SSH public key is empty"
    exit 1
fi

# Check existing keys
EXISTING_KEYS=$(curl -s -X GET -H "Authorization: Bearer $DO_API_TOKEN" "https://api.digitalocean.com/v2/account/keys")
if echo "$EXISTING_KEYS" | grep -q "unauthorized"; then
    echo "Error: Failed to authenticate with DigitalOcean. Please check your API token."
    echo "API Response: $EXISTING_KEYS"
    exit 1
fi

# Delete all existing SSH keys
echo "Cleaning up all existing SSH keys..."
for id in $(parse_json "$EXISTING_KEYS" "id"); do
    if [ -n "$id" ]; then
        echo "Deleting key with ID: $id"
        curl -s -X DELETE -H "Authorization: Bearer $DO_API_TOKEN" "https://api.digitalocean.com/v2/account/keys/$id"
    fi
done

# Wait for deletion to complete
sleep 2

# Create new SSH key
echo "Creating new SSH key..."
KEY_NAME="vagrant-wordpress-key-$(date +%s)"
echo "Using key name: $KEY_NAME"

KEY_RESPONSE=$(curl -s -X POST -H "Content-Type: application/json" \
    -H "Authorization: Bearer $DO_API_TOKEN" \
    -d "{\"name\":\"$KEY_NAME\",\"public_key\":\"$SSH_KEY\"}" \
    "https://api.digitalocean.com/v2/account/keys")

KEY_ID=$(parse_json "$KEY_RESPONSE" "id")

if [ -z "$KEY_ID" ] || [ "$KEY_ID" = "null" ]; then
    echo "Failed to create SSH key"
    echo "API Response:"
    echo "$KEY_RESPONSE"
    exit 1
fi

echo "Successfully created new SSH key with ID: $KEY_ID"

# Update vars.yml with the key ID
echo "Updating vars.yml with SSH key ID..."
sed -i.bak "s/ssh_key_name:.*/ssh_key_name: $KEY_ID/" vars.yml

# Install required Vagrant plugin without confirmation
echo "Installing required Vagrant plugin..."
VAGRANT_DISABLE_STRICT_DEPENDENCY_ENFORCEMENT=1 vagrant plugin install vagrant-hostmanager --plugin-clean-sources --plugin-source https://rubygems.org

# Start Vagrant environment with auto-approve
echo "Starting Vagrant environment..."
VAGRANT_NO_PARALLEL=1 VAGRANT_DISABLE_STRICT_DEPENDENCY_ENFORCEMENT=1 vagrant up --no-tty --provider=virtualbox --no-destroy-on-error

echo "Setup completed successfully!"
echo "Your WordPress environment should now be accessible at: http://localhost:8080"
echo "PHPMyAdmin should be accessible at: http://localhost:8081"