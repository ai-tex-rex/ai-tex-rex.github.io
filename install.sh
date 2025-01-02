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

# Copy necessary files
echo "[INFO] Copying necessary files..."
files_to_copy=(
    "tex_rex.ipynb"
    "abstract/abstract_maker.py"
    "introduction/introduction_maker.py"
    "methods/methods_maker.py"
    "results_discussion/results_maker.py"
    "conclusion/conclusion_maker.py"
    "figure/figure_maker.py"
    "abstract/prompt_coll/analysis_template.md"
    "introduction/intro_prompt_coll/analysis_template.md"
    "methods/methods_prompt_coll/analysis_template.md"
    "results_discussion/results_prompt_coll/analysis_template.md"
    "conclusion/conclusion_prompt_coll/analysis_template.md"
    "figure/fig_prompt_coll/analysis_template.md"
)

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

# Clean up
echo "[INFO] Cleaning up..."
rm -rf $TEMP_DIR $ZIP_FILE

echo "=== Setup complete! Please check any warnings above. ==="
echo "[INFO] To get started, open tex_rex.ipynb in Jupyter Notebook." 