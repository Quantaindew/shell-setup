#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (use sudo)"
    exit 1
fi

# Check if username was provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <username>"
    echo "Example: $0 john"
    exit 1
fi

USERNAME=$1

# Check if user already exists
if id "$USERNAME" &>/dev/null; then
    echo "Error: User '$USERNAME' already exists"
    exit 1
fi

echo "==================================="
echo "Creating new user: $USERNAME"
echo "==================================="

# Update system packages (optional - comment out if not needed)
#echo "Updating system packages..."
#apt update && apt upgrade -y

# Create the new user with home directory
echo "Creating user '$USERNAME'..."
adduser "$USERNAME"

# Check if user was created successfully
if [ $? -ne 0 ]; then
    echo "Error: Failed to create user"
    exit 1
fi

# Add user to sudo group
echo "Adding $USERNAME to sudo group..."
usermod -aG sudo "$USERNAME"

# Set up SSH directory and permissions
echo "Setting up SSH access for $USERNAME..."
mkdir -p /home/"$USERNAME"/.ssh

# Copy SSH keys from root if they exist
if [ -f /root/.ssh/authorized_keys ]; then
    echo "Copying SSH authorized keys..."
    cp /root/.ssh/authorized_keys /home/"$USERNAME"/.ssh/
else
    echo "No SSH keys found in /root/.ssh/authorized_keys"
    echo "You may want to manually add SSH keys later"
fi

# Set proper ownership and permissions
chown -R "$USERNAME":"$USERNAME" /home/"$USERNAME"/.ssh
chmod 700 /home/"$USERNAME"/.ssh

if [ -f /home/"$USERNAME"/.ssh/authorized_keys ]; then
    chmod 600 /home/"$USERNAME"/.ssh/authorized_keys
fi

echo "==================================="
echo "User '$USERNAME' created successfully!"
echo "==================================="
echo ""
echo "Summary:"
echo "  - User: $USERNAME"
echo "  - Home: /home/$USERNAME"
echo "  - Groups: $(groups $USERNAME)"
echo "  - SSH: Configured (keys copied from root if available)"
echo ""
echo "You can now login as '$USERNAME' using:"
echo "  - su - $USERNAME"
echo "  - ssh $USERNAME@$(hostname -I | awk '{print $1}')"
echo ""
