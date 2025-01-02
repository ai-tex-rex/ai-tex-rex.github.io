#!/bin/bash

echo "=== Setting up tex-Rex ==="

# Check Python version
if ! command -v python3 &> /dev/null; then
    echo "[ERROR] Python 3 is required but not installed."
    exit 1
fi

# Check pip
if ! command -v pip3 &> /dev/null; then
    echo "[ERROR] pip3 is required but not installed."
    exit 1
fi

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

# Check if main notebook exists
if [ ! -f "tex_rex.ipynb" ]; then
    echo "[WARNING] Main notebook (tex_rex.ipynb) not found!"
    echo "Please make sure to copy it from the repository."
fi

# Check for template files
template_files=(
    "abstract/prompt_coll/analysis_template.md"
    "introduction/intro_prompt_coll/analysis_template.md"
    "methods/methods_prompt_coll/analysis_template.md"
    "results_discussion/results_prompt_coll/analysis_template.md"
    "conclusion/conclusion_prompt_coll/analysis_template.md"
    "figure/fig_prompt_coll/analysis_template.md"
)

echo "[INFO] Checking template files..."
for file in "${template_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo "[WARNING] Missing template file: $file"
    fi
done

echo "=== Setup complete! Please check any warnings above. ==="
echo "[INFO] To get started, open tex_rex.ipynb in Jupyter Notebook." 