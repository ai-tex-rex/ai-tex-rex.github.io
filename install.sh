#!/bin/bash

echo "=== Setting up tex-Rex ==="

# Repository URL
REPO_ZIP="https://github.com/ai-tex-rex/ai-tex-rex.github.io/archive/refs/heads/main.zip"
ZIP_FILE="tex_rex.zip"

# Check Python version
python_version=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
if [ "$(printf '%s\n' "3.10" "$python_version" | sort -V | head -n1)" != "3.10" ]; then
    echo "[ERROR] Python 3.10 or higher is required. Current version: $python_version"
    exit 1
fi

# Download repository
echo "[INFO] Downloading repository..."
if ! curl -L $REPO_ZIP -o $ZIP_FILE 2>/dev/null; then
    if ! wget $REPO_ZIP -O $ZIP_FILE 2>/dev/null; then
        echo "[ERROR] Failed to download repository. Please check your internet connection."
        exit 1
    fi
fi

# Extract files
echo "[INFO] Extracting files..."
unzip -q $ZIP_FILE
mv ai-tex-rex.github.io-main/* .
rm -rf ai-tex-rex.github.io-main $ZIP_FILE

# Check required Python packages
echo "[INFO] Checking Python packages..."
required_packages=(httpx ipython jupyter notebook)
missing_packages=()

for package in "${required_packages[@]}"; do
    if ! pip3 list | grep -F "$package" &> /dev/null; then
        missing_packages+=("$package")
    fi
done

if [ ${#missing_packages[@]} -ne 0 ]; then
    echo "[WARNING] Missing required packages: ${missing_packages[*]}"
    echo "Please install them using: pip3 install ${missing_packages[*]}"
fi

echo "=== Setup complete! ==="
echo "[INFO] To get started, open tex_rex.ipynb in Jupyter Notebook."

# Self-delete the install script
rm -- "$0" 