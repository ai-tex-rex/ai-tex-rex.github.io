# tex-Rex 🦖

tex-Rex is an AI-powered academic paper analysis tool that helps researchers improve their scientific manuscripts through automated feedback and suggestions. It uses OpenRouter API to access advanced language models for comprehensive paper analysis.

## Installation

### Requirements
- Python 3.10 or higher
- pip3
- curl or wget
- unzip

### Quick Install
```bash
# Using curl
curl -O https://raw.githubusercontent.com/ai-tex-rex/tex-rex.github.io/main/install.sh && chmod +x install.sh && ./install.sh

# Or using wget
wget https://raw.githubusercontent.com/ai-tex-rex/tex-rex.github.io/main/install.sh && chmod +x install.sh && ./install.sh
```

The install script will:
1. Check system requirements
2. Download necessary files
3. Set up the project structure
4. Install required Python packages

## Project Structure

The project is organized into several key components:

```
tex-rex/
├── abstract/               # Abstract analysis component
│   ├── abstract_maker.py  # Abstract analysis implementation
│   └── prompt_coll/       # Analysis templates and prompts
├── introduction/           # Introduction analysis component
│   ├── introduction_maker.py
│   └── intro_prompt_coll/
├── methods/               # Methods analysis component
│   ├── methods_maker.py
│   └── methods_prompt_coll/
├── results_discussion/    # Results analysis component
│   ├── results_maker.py
│   └── results_prompt_coll/
├── conclusion/            # Conclusion analysis component
│   ├── conclusion_maker.py
│   └── conclusion_prompt_coll/
├── figure/               # Figure analysis component
│   ├── figure_maker.py
│   └── fig_prompt_coll/
├── tex_rex.ipynb         # Main notebook for analysis
```

## Documentation

Visit our [documentation site](https://ai-tex-rex.github.io/tex-rex.github.io) for detailed information about usage and components.

## Features

Each component provides detailed analysis through specialized analyzers:

- 📝 **Abstract Analysis**: Evaluates abstracts using `AbstractAnalyzer` class
  - Provides section-by-section analysis
  - Generates both general recommendations and specific actions
  - Uses customizable analysis templates and guidelines

- 📚 **Introduction Review**: Uses `IntroductionAnalyzer` for comprehensive review
  - Analyzes structure and content against best practices
  - Provides targeted improvement suggestions
  - Supports customizable evaluation criteria

- 🧪 **Methods Evaluation**: Implements `MethodsAnalyzer` for methodology review
  - Checks completeness and clarity of methods description
  - Suggests improvements for reproducibility
  - Evaluates technical details and procedures

- 📊 **Results Assessment**: Uses `ResultsAnalyzer` to evaluate findings
  - Reviews data presentation and interpretation
  - Checks statistical analysis and significance
  - Suggests improvements for clarity and impact

- 🎯 **Conclusion Analysis**: Employs `ConclusionAnalyzer` for evaluation
  - Assesses conclusion strength and relevance
  - Checks alignment with research objectives
  - Suggests improvements for impact

- 🖼️ **Figure Analysis**: Uses `FigureAnalyzer` for visual content
  - Evaluates figure clarity and effectiveness
  - Suggests improvements for visual presentation
  - Reviews caption completeness and accuracy

## Technical Implementation

- **AI Integration**: Uses OpenRouter API to access advanced language models (default: Claude-3.5-Sonnet, Llama-3.1)
- **Async Processing**: Implements asynchronous analysis for efficient processing
- **Modular Design**: Each component follows the same structure:
  - `*_maker.py`: Main analyzer class implementation
  - `prompt_coll/`: Contains analysis templates and guidelines
  - JSON data files for evaluation criteria

## Usage

The project is structured as a collection of Jupyter notebooks and Python modules. The main analysis is performed through `tex_rex.ipynb`, which coordinates the various analysis components.

Example usage in the notebook:
```python
# Initialize analyzer
analyzer = AbstractAnalyzer(api_key="your-openrouter-api-key")

# Analyze text
result = await analyzer.analyze_abstract(your_text)

# Display results
analyzer.display_results(result)
```

## Contributing

We welcome contributions! Please see our [contributing guidelines](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 