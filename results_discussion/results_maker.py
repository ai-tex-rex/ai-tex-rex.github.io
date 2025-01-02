import httpx
import asyncio
from IPython.display import display, Markdown
import json
import re
import ast
from typing import List, Dict, Any, Optional

class ResultsAnalyzer:
    def __init__(self, api_key: str, 
                 analysis_template: str = 'results_discussion/results_prompt_coll/analysis_template.md',
                 total_template: str = 'results_discussion/results_prompt_coll/total_template.md',
                 results_data: str = 'results_discussion/results_data.json'
    ):
        self.api_key = api_key
        self.analysis_template = self._load_template(analysis_template)
        self.total_template = self._load_template(total_template)
        self.results_data = self._load_json(results_data)

    @staticmethod
    def _load_template(path: str) -> str:
        with open(path, 'r') as f:
            return f.read()

    @staticmethod
    def _load_json(path: str) -> List[Dict]:
        with open(path, 'r') as f:
            return json.load(f)

    async def _openr_chat(
        self,
        message: str,
        model: str = "meta-llama/llama-3.1-405b-instruct",
        extra_params: Optional[Dict] = None
    ) -> Optional[str]:
        if extra_params is None:
            extra_params = {"temperature": 0.0, "max_tokens": 5000}

        url = "https://openrouter.ai/api/v1/chat/completions"
        payload = {
            "model": model,
            **extra_params,
            "messages": [{"role": "user", "content": message}]
        }
        headers = {"Authorization": f"Bearer {self.api_key}"}

        try:
            async with httpx.AsyncClient() as client:
                response = await client.post(url, headers=headers, json=payload)
                response.raise_for_status()
                out_ = response.json()
                content = out_['choices'][0]['message']['content']
                if not content:
                    raise ValueError("No messages found in the response.")
                return content
        except Exception as e:
            print(f"An error occurred: {str(e)}")
            return None

    def create_markdown_section(self, target_title_indx: int) -> str:
        if target_title_indx >= len(self.results_data):
            return "Section not found"
            
        section = self.results_data[target_title_indx]
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

    async def analyze_results(self, results_discussion: str, model: str = "anthropic/claude-3.5-sonnet") -> str:
        # Generate prompts collection
        g_prompt_coll = []
        for indx in range(len(self.results_data)):
            guidelines = self.create_markdown_section(indx)
            t_ = self.analysis_template.format(user_results_discussion_section=results_discussion, guidelines=guidelines)
            g_prompt_coll.append(t_)

        # Process all prompts
        results = await asyncio.gather(*[self._openr_chat(t, model=model) for t in g_prompt_coll])

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
            tot_text += self.format_improvement_instructions(i[1]['results_discussion_improvement_instructions'])
            tot_text += "-"*50 + "\n"

        self.analysis_results = results
        self.analysis_results_condensed = tot_text
        # Generate final analysis
        final_prompt = self.total_template.format(user_results_discussion_section=results_discussion, tot_results=tot_text)
        final_result = await self._openr_chat(final_prompt, model=model)
        
        return final_result

    def display_results(self, results: str) -> None:
        display(Markdown(results))
