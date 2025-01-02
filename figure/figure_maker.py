import httpx
import asyncio
from IPython.display import display, Markdown
import json
import re
import ast
import base64
from typing import List, Dict, Any, Optional

class FigureAnalyzer:
    def __init__(self, api_key: str, 
                 analysis_template: str = 'figure/fig_prompt_coll/analysis_template.md',
                 total_template: str = 'figure/fig_prompt_coll/total_template.md',
                 figures_data: str = 'figure/figures_data.json'
    ):
        self.api_key = api_key
        self.analysis_template = self._load_template(analysis_template)
        self.total_template = self._load_template(total_template)
        self.figures_data = self._load_json(figures_data)

    @staticmethod
    def _load_template(path: str) -> str:
        with open(path, 'r') as f:
            return f.read()

    @staticmethod
    def _load_json(path: str) -> List[Dict]:
        with open(path, 'r') as f:
            return json.load(f)

    @staticmethod
    def encode_image(image_path):
        with open(image_path, "rb") as image_file:
            return base64.b64encode(image_file.read()).decode("utf-8")

    async def openr_chat(
        self,
        message: str,
        image_path: str = None,
        extra_params: dict = None,
        model: str = "meta-llama/llama-3.1-405b-instruct"
    ):
        # Set default values for extra_params safely
        if extra_params is None:
            extra_params = {"temperature": 0.0, "max_tokens": 5000}

        url = "https://openrouter.ai/api/v1/chat/completions"
        
        # Prepare message content
        content = []
        content.append({"type": "text", "text": message})
        
        # Add image if provided
        if image_path:
            try:
                base64_image = await asyncio.to_thread(self.encode_image, image_path)
                content.append({
                    "type": "image_url",
                    "image_url": {"url": f"data:image/png;base64,{base64_image}"}
                })
            except Exception as e:
                print(f"Error encoding image: {str(e)}")
                return None

        # Prepare request payload
        payload = {
            "model": model,
            **extra_params,
            "messages": [
                {
                    "role": "user",
                    "content": content
                }
            ]
        }
        
        headers = {
            "Authorization": f"Bearer {self.api_key}",
            # Add optional headers if needed
            # "HTTP-Referer": f"{YOUR_SITE_URL}",
            # "X-Title": f"{YOUR_APP_NAME}",
        }

        try:
            # Use an async HTTP client with timeout
            async with httpx.AsyncClient(timeout=300.0) as client:
                response = await client.post(url, headers=headers, json=payload)

                # Raise an exception for non-2xx status codes
                response.raise_for_status()

                # Parse JSON response
                out_ = response.json()
                
                # Extract required fields with fallback handling
                usage = out_.get("usage", {})
                content = out_['choices'][0]['message']['content']
                if not content:
                    raise ValueError("No messages found in the response.")
                                
                return content
        
        except httpx.HTTPStatusError as e:
            print(f"HTTP error occurred: {e.response.status_code} - {e.response.text}")
            return None
        except Exception as e:
            print(f"An unexpected error occurred: {str(e)}")
            return None
    

    def create_markdown_section(self, target_title_indx: int) -> str:
        if target_title_indx >= len(self.figures_data):
            return "Section not found"
            
        section = self.figures_data[target_title_indx]
        markdown = f"# {section['title']}\n\n"
        
        if "subsections" in section:
            for subsection_title, content in section["subsections"].items():
                markdown += f"## {subsection_title}\n\n"
                
                if isinstance(content, dict):
                    for sub_title, items in content.items():
                        markdown += f"### {sub_title}\n"
                        for item in items:
                            markdown += f"- {item}\n"
                        markdown += "\n"
                elif isinstance(content, list):
                    for item in content:
                        markdown += f"- {item}\n"
                    markdown += "\n"
        
        if "items" in section:
            for item in section["items"]:
                markdown += f"- {item}\n"
        
        return markdown

    @staticmethod
    def format_improvement_instructions(instructions_dict: Dict) -> str:
        output = []
        output.append("GENERAL RECOMMENDATIONS:")
        for i, rec in enumerate(instructions_dict['general_recommendations'], 1):
            output.append(f"{i}. {rec}")
        
        output.append("\nSPECIFIC ACTIONS:")
        for i, action in enumerate(instructions_dict['specific_actions'], 1):
            output.append(f"{i}. Action: {action['action']}")
            output.append(f"   Target: {action['target']}")
            output.append(f"   Expected Outcome: {action['expected_outcome']}")
            output.append("")
        
        return "\n".join(output)

    async def analyze_figures(self,
                              image_path: str = None,
                              model: str = "anthropic/claude-3.5-sonnet") -> str:
        # Generate prompts collection
        g_prompt_coll = []
        for indx in range(len(self.figures_data)):
            guidelines = self.create_markdown_section(indx)
            t_ = self.analysis_template.format(user_data_visualization=image_path, guidelines=guidelines)
            g_prompt_coll.append(t_)

        # Process prompts in batches of 5
        results = []
        for i in range(0, len(g_prompt_coll), 5):
            batch = g_prompt_coll[i:i+5]
            batch_results = await asyncio.gather(*[self.openr_chat(t, image_path=image_path, model=model) for t in batch])
            results.extend(batch_results)

        # Parse results
        out_coll = []

        for indx, res in enumerate(results):
            if res:
                code_block = re.search(r'```json\n(.*?)```', res, re.DOTALL)
                if code_block:
                    code_block = code_block.group(1)
                    try:
                        py = ast.literal_eval(code_block)
                    except:
                        py = json.loads(code_block)
                    out_coll.append([indx, py])

        # Format total results
        tot_text = ""
        for i in out_coll:
            tot_text += self.format_improvement_instructions(i[1]['visualization_improvement_instructions'])
            tot_text += "-"*50 + "\n"

        self.analysis_results = results
        self.analysis_results_condensed = tot_text
        # Generate final analysis
        final_prompt = self.total_template.format(tot_results=tot_text)
        final_result = await self.openr_chat(final_prompt, model=model)
        
        return final_result

    def display_results(self, results: str) -> None:
        display(Markdown(results))
