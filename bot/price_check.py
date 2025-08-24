# price_check.py

# This module contains the logic to fetch the current ETH price from CoinGecko.


import requests

def get_eth_price_coingecko() -> float:
    url = "https://api.coingecko.com/api/v3/simple/price"
    params = {
        "ids": "ethereum",
        "vs_currencies": "usd"
    }
    responce = requests.get(url, params=params)
    data = responce.json()
    return data["ethereum"]["usd"]