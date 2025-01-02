#!/bin/bash

echo "=== Setting up tex-Rex ==="

# Repository URL for downloading zip
REPO_ZIP="https://github.com/ai-tex-rex/ai-tex-rex.github.io/archive/refs/heads/main.zip"
TEMP_DIR="temp_tex_rex"
ZIP_FILE="tex_rex.zip"

# Check Python version
if ! command -v python3 &> /dev/null; then
    echo "[ERROR] Python 3 is required but not installed."
    exit 1
fi

# Check Python version is at least 3.10
python_version=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
if [ "$(printf '%s\n' "3.10" "$python_version" | sort -V | head -n1)" != "3.10" ]; then
    echo "[ERROR] Python 3.10 or higher is required. Current version: $python_version"
    exit 1
fi

# Check pip
if ! command -v pip3 &> /dev/null; then
    echo "[ERROR] pip3 is required but not installed."
    exit 1
fi

# Download files using curl or wget
echo "[INFO] Downloading necessary files..."
if command -v curl &> /dev/null; then
    curl -L $REPO_ZIP -o $ZIP_FILE
elif command -v wget &> /dev/null; then
    wget $REPO_ZIP -O $ZIP_FILE
else
    echo "[ERROR] Neither curl nor wget is installed. Please install one of them."
    exit 1
fi

# Extract files
echo "[INFO] Extracting files..."
mkdir -p $TEMP_DIR
if command -v unzip &> /dev/null; then
    unzip -q $ZIP_FILE -d $TEMP_DIR
else
    echo "[ERROR] unzip is not installed. Please install it."
    rm -f $ZIP_FILE
    exit 1
fi

# Move to the correct directory
mv $TEMP_DIR/*/* $TEMP_DIR/

# Create necessary directories if they don't exist
directories=(
    "abstract/prompt_coll"
    "introduction/intro_prompt_coll"
    "methods/methods_prompt_coll"
    "results_discussion/results_prompt_coll"
    "conclusion/conclusion_prompt_coll"
    "figure/fig_prompt_coll"
)

echo "[INFO] Setting up directory structure..."
for dir in "${directories[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo "Created directory: $dir"
    fi
done

# After creating directories, scan for files
echo "[INFO] Scanning repository contents..."
declare -A module_dirs=(
    ["abstract"]="abstract"
    ["introduction"]="introduction"
    ["methods"]="methods"
    ["results_discussion"]="results_discussion"
    ["conclusion"]="conclusion"
    ["figure"]="figure"
)

# First, let's find all relevant files
files_to_copy=("tex_rex.ipynb")
for module in "${!module_dirs[@]}"; do
    dir="${module_dirs[$module]}"
    
    # Find all Python files
    while IFS= read -r pyfile; do
        if [ -f "$TEMP_DIR/$pyfile" ]; then
            files_to_copy+=("$pyfile")
        fi
    done < <(find "$TEMP_DIR/$dir" -name "*.py" -type f -printf "%P\n")
    
    # Find all JSON files
    while IFS= read -r jsonfile; do
        if [ -f "$TEMP_DIR/$jsonfile" ]; then
            files_to_copy+=("$jsonfile")
        fi
    done < <(find "$TEMP_DIR/$dir" -name "*.json" -type f -printf "%P\n")
    
    # Find all Markdown files
    while IFS= read -r mdfile; do
        if [ -f "$TEMP_DIR/$mdfile" ]; then
            files_to_copy+=("$mdfile")
        fi
    done < <(find "$TEMP_DIR/$dir" -name "*.md" -type f -printf "%P\n")
done

# Print found files for verification
echo "[INFO] Found the following files to copy:"
printf '%s\n' "${files_to_copy[@]}"

# Copy files
for file in "${files_to_copy[@]}"; do
    if [ -f "$TEMP_DIR/$file" ]; then
        dir=$(dirname "$file")
        mkdir -p "$dir"
        cp "$TEMP_DIR/$file" "$file"
        echo "Copied: $file"
    else
        echo "[WARNING] Could not find: $file"
    fi
done

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

# Use the same list for essential files
essential_files=("${files_to_copy[@]}")

# After extraction, verify essential files
echo "[INFO] Verifying repository contents..."
missing_files=()
for file in "${essential_files[@]}"; do
    if [ ! -f "$TEMP_DIR/$file" ]; then
        missing_files+=("$file")
    fi
done

if [ ${#missing_files[@]} -ne 0 ]; then
    echo "[ERROR] Repository is missing essential files:"
    printf '%s\n' "${missing_files[@]}"
    echo "Please check the repository structure or contact the maintainers."
    rm -rf $TEMP_DIR $ZIP_FILE
    exit 1
fi

# Clean up
echo "[INFO] Cleaning up..."
rm -rf $TEMP_DIR $ZIP_FILE

echo "=== Setup complete! Please check any warnings above. ==="
echo "[INFO] To get started, open tex_rex.ipynb in Jupyter Notebook."

# Self-delete the install script
rm -- "$0" 