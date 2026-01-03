#!/bin/bash

# Exit on error
set -e

# Ask for a commit message
echo "Enter commit message:"
read msg

# Stage everything
git add .

# Commit
git commit -m "$msg"

# Push to main
git push origin main
