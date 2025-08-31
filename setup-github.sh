#!/bin/bash

# Git Setup Script
# Usage: ./setup-git.sh "your-email@example.com" "Your Name"

# Check if correct number of arguments provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <email> <name>"
    echo "Example: $0 'user@example.com' 'John Doe'"
    exit 1
fi

# Assign parameters to variables
USER_EMAIL="$1"
USER_NAME="$2"

echo "Starting Git and GitHub CLI setup..."
echo "Email: $USER_EMAIL"
echo "Name: $USER_NAME"
echo ""

# Update package list and install git and GitHub CLI
echo "Installing git and GitHub CLI..."
sudo apt-get update && sudo apt-get install gh git -y --no-install-recommends

# Check if installation was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to install git and/or GitHub CLI"
    exit 1
fi

echo "Setting up Git configuration..."

# Configure Git with provided email and name
git config --global user.email "$USER_EMAIL"
git config --global user.name "$USER_NAME"

# Verify configuration
echo ""
echo "Git configuration set:"
echo "Email: $(git config --global user.email)"
echo "Name: $(git config --global user.name)"
echo ""

# Authenticate with GitHub
echo "Starting GitHub CLI authentication..."
echo "Please follow the prompts to authenticate with GitHub:"
gh auth login

# Check if authentication was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Git and GitHub CLI setup completed successfully!"
    echo "You can now use git and gh commands."
else
    echo ""
    echo "⚠️  GitHub authentication failed or was cancelled."
    echo "You can run 'gh auth login' later to authenticate."
fi
