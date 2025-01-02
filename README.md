# TeX-Rex

TeX-Rex is an AI-powered academic paper analysis tool that helps researchers improve their scientific manuscripts through automated feedback and suggestions.

## Documentation

Visit our [documentation site](https://ai-tex-rex.github.io/tex-rex/) for detailed information about installation, usage, and API reference.

## Quick Start

```bash
# Install the package
pip install tex-rex

# Set up your API key
export OPENAI_API_KEY="your-api-key-here"
```

```python
# Example usage
from tex_rex import TexRex

analyzer = TexRex(api_key="your-api-key")

# Analyze abstract
result = await analyzer.analyze_abstract(text)
analyzer.display_results(result)
```

## Features

- 📝 Abstract Analysis
- 📚 Introduction Review
- 🧪 Methods Evaluation
- 📊 Results Assessment
- 🎯 Conclusion Analysis
- 🖼️ Figure Analysis

## Contributing

We welcome contributions! Please see our [contributing guidelines](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 