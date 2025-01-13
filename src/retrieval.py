from transformers import AutoModelForCausalLM, AutoTokenizer

model_name = "meta/code-llama"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained(model_name)

from sentence_transformers import SentenceTransformer

retrieval_model = SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2")
