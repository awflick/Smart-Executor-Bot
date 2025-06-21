import json

def load_abi(path: str) -> list:
    with open(path) as f:
        return json.load(f)["abi"]