# tex-Rex 🦖

<img src="logo.png" alt="tex-Rex Logo" width="200">

`tex-Rex` is an AI-powered academic paper analysis tool that helps researchers improve their scientific manuscripts through automated feedback and suggestions. 
Start writing in your native language! 🇨🇳 🇧🇷 🇫🇷 🇰🇷 🇯🇵 🇪🇸 
## About

The tool will remain faithful to the original writing of the author but suggests improvement and asks for missing information. It can handle multiple languages, so you can start writing in your native language and it will do the analysis and then translate to English. It uses OpenRouter API to access advanced language models for comprehensive paper analysis.
Inspired by MIT's Nuclear Science and Engineering Communication Lab guidelines, `tex-Rex` provides automated feedback for each section of your scientific paper. Our analysis is based on established best practices in scientific communication and helps you craft clear, effective technical documents.

## Installation

### Requirements
- Python 3.10 or higher
- pip3
- curl or wget
- unzip
- httpx
- ipython
- jupyter
- notebook

### Quick Install
```bash
# Using curl
curl -O https://raw.githubusercontent.com/ai-tex-rex/ai-tex-rex.github.io/main/install.sh && chmod +x install.sh && ./install.sh

# Or using wget
wget https://raw.githubusercontent.com/ai-tex-rex/ai-tex-rex.github.io/main/install.sh && chmod +x install.sh && ./install.sh
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

Visit our [documentation site](https://ai-tex-rex.github.io) and [jupyter notebook](tex_rex.ipynb) for detailed information about usage and components.

## Features

Each component provides detailed analysis through specialized analyzers, following established scientific writing guidelines:

- 📝 **Abstract Analysis**: Evaluates abstracts using `AbstractAnalyzer` class
  - Provides comprehensive structural analysis
  - Ensures all key components are present
  - Checks clarity and impact of your research summary
  - Suggests improvements for better reader engagement

- 📚 **Introduction Review**: Uses `IntroductionAnalyzer` for comprehensive review
  - Evaluates background information and context
  - Checks research gap identification
  - Assesses objectives and hypothesis statements
  - Ensures proper literature review integration

- 🧪 **Methods Evaluation**: Implements `MethodsAnalyzer` for methodology review
  - Ensures reproducibility of procedures
  - Checks completeness of experimental details
  - Validates technical accuracy and clarity
  - Reviews statistical approach appropriateness

- 📊 **Results Assessment**: Uses `ResultsAnalyzer` to evaluate findings
  - Analyzes data presentation effectiveness
  - Checks statistical analysis validity
  - Ensures clear connection to research questions
  - Reviews result interpretation clarity

- 🎯 **Conclusion Analysis**: Employs `ConclusionAnalyzer` for evaluation
  - Verifies alignment with research objectives
  - Checks impact statement clarity
  - Evaluates future work suggestions
  - Ensures proper research context placement

- 🖼️ **Figure Analysis**: Uses `FigureAnalyzer` for visual content
  - Applies scientific figure design principles
  - Checks visual clarity and effectiveness
  - Reviews caption completeness
  - Ensures proper data representation

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

## Acknowledgments

`tex-Rex`'s analysis criteria are inspired by the scientific communication guidelines from MIT's Nuclear Science and Engineering Communication Lab (NSE CommLab). While our tool provides automated feedback, we encourage users to also refer to the original [NSE CommKit](https://mitcommlab.mit.edu/nse/use-the-commkit/) for detailed writing guidelines.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 