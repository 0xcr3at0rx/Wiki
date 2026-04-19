#!/bin/sh
set -e

# Default installation directory
PREFIX="${PREFIX:-/usr/local/bin}"

# Ensure the scripts directory exists
if [ ! -d "scripts" ]; then
    echo "Error: scripts directory not found."
    exit 1
fi

# Create target directory if it doesn't exist
mkdir -p "$PREFIX"

# Install each script found in the scripts folder
for script_path in scripts/*; do
    if [ -f "$script_path" ]; then
        script_name=$(basename "$script_path")
        echo "Installing $script_name to $PREFIX"
        cp "$script_path" "$PREFIX/$script_name"
        chmod +x "$PREFIX/$script_name"
    fi
done

echo "Installation complete!"
