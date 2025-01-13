Here's how you can set up a development environment for your VS Code extension project:

### 1. **Set Up Python Environment**
Create a virtual environment to manage dependencies:
```bash
python3 -m venv venv
source venv/bin/activate  # On Windows, use venv\Scripts\activate
```

### 2. **Install Required Libraries**
Install the necessary libraries:
```bash
pip install langgraph langchain huggingface_hub transformers torch accelerate bitsandbytes
```

### 3. **Configure VS Code for Development**
- Install the [Python extension](https://marketplace.visualstudio.com/items?itemName=ms-python.python) for VS Code.
- Set up a `.vscode/settings.json` file:
```json
{
  "python.pythonPath": "./venv/bin/python",
  "python.linting.enabled": true,
  "python.formatting.provider": "black",
  "editor.formatOnSave": true
}
```

### 4. **Set Up Open Source Models**
#### a. **Code Generation Models**
You can load these models from Hugging Face:
```python
from transformers import AutoModelForCausalLM, AutoTokenizer

model_name = "meta/code-llama"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained(model_name)
```

#### b. **Retrieval Models**
For models like `BAAI/bge-small-en-v1.5` and `sentence-transformers/all-MiniLM-L6-v2`:
```python
from sentence_transformers import SentenceTransformer

retrieval_model = SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2")
```

#### c. **Microsoft Phi4 - SLM**
If this is hosted privately, ensure you have the right access tokens from Microsoft or the appropriate API endpoint.

### 5. **Set Up Accelerated Runtime**
- CPU-only systems:
    - `bitsandbytes` can handle optimization on CPUs.
    - Add `device_map="auto"` when loading models to ensure efficient resource allocation.
- If you decide to add a GPU later:
    - Install the GPU version of PyTorch.
    - Update your `.vscode/settings.json` to include the correct CUDA path.

### 6. **Extension Architecture**
Create a folder structure:
```
my-vscode-extension/
├── src/
│   ├── main.py  # Main entry point
│   ├── code_generation.py  # Code generation logic
│   ├── retrieval.py  # Retrieval logic
├── venv/  # Virtual environment
├── requirements.txt  # Dependency list
├── README.md  # Documentation
```

### 7. **Testing and Debugging**
Use the `launch.json` in `.vscode` to configure debugging:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Python: Current File",
      "type": "python",
      "request": "launch",
      "program": "${file}",
      "console": "integratedTerminal"
    }
  ]
}
```

### 8. **Package Your Extension**
Create a `setup.py` or `pyproject.toml` for packaging, and include VS Code API hooks if integrating directly.

If you need further guidance, let me know!