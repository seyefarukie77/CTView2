#!/bin/bash

# Exit immediately if a command fails
set -e

# Ask for commit message
echo "Enter commit message:"
read msg

# Stage all changes
git add .

# Commit
git commit -m "$msg"

# Force push to the current branch
current_branch=$(git rev-parse --abbrev-ref HEAD)
git push origin "$current_branch" --force

echo "Force push to '$current_branch' completed."
