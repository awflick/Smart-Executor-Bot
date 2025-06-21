# trigger_bot.py

from web3 import Web3
import os
from utils.load_abi import load_abi
from price_check import get_eth_price_coingecko
from eth_account import Account
from swap_executor import execute_real_swap
from utils.logger import log_event

# -----------------------------
# 🔧 Load environment settings
# -----------------------------
LIVE_MODE = os.environ.get("LIVE_MODE", "false").lower() == "true"
RPC_URL = os.environ.get("ANVIL_RPC_URL")
PRIVATE_KEY = os.environ.get("ANVIL_PRIVATE_KEY")
RECIPIENT = os.environ.get("RECIPIENT")
SWAP_EXECUTOR = Web3.to_checksum_address(os.environ.get("SWAP_EXECUTOR"))

TOKEN_IN = Web3.to_checksum_address(os.environ.get("TOKEN_IN"))
TOKEN_OUT = Web3.to_checksum_address(os.environ.get("TOKEN_OUT"))
AMOUNT_IN_ETH = 1.0
MIN_OUT_ETH = 0.01

# -----------------------------
# 🌐 Set up Web3
# -----------------------------
print("🔍 Running in ANVIL (Local) mode")
print(f"RPC_URL: {RPC_URL}")
print("Using Private Key: ANVIL")

w3 = Web3(Web3.HTTPProvider(RPC_URL))

assert w3.is_connected(), f"Web3 connection failed for {RPC_URL}"

# -----------------------------
# 📄 Load contract and ABI
# -----------------------------
swap_executor_abi = load_abi("out/SwapExecutor.sol/SwapExecutor.json")
swap_executor = w3.eth.contract(address=SWAP_EXECUTOR, abi=swap_executor_abi)

# -----------------------------
# 🚀 Main Bot Logic
# -----------------------------
def main():
    print("Bot initialized")
    account = Account.from_key(PRIVATE_KEY)
    print(f"🔑 Account loaded: {account.address}")
    print(f"Account balance: {w3.eth.get_balance(account.address)} wei")
    
    eth_price = get_eth_price_coingecko()
    print(f"Current ETH Price: ${eth_price}")

    if eth_price > 2500:
        msg = "✅ Condition met! (ETH > $2500) — Ready to trigger swap"
        print(msg)
        log_event(msg, "logs/bot.log")

        try:
            print(f"🧪 SWAP DEBUG")
            print(f"Token In: {TOKEN_IN}")
            print(f"Token Out: {TOKEN_OUT}")
            print(f"Router: {swap_executor.address}")

            tx_hash = execute_real_swap(
                w3=w3,
                contract=swap_executor,
                private_key=PRIVATE_KEY,
                token_in=TOKEN_IN,
                token_out=TOKEN_OUT,
                recipient=Web3.to_checksum_address(RECIPIENT),
                pool_fee=3000,
                amount_in_eth=1,        # or whatever you're testing with
                min_out_eth=0.1         # conservative estimate
            )
            
            network_label = "LIVE" if LIVE_MODE else "ANVIL"
            print(f"🔁 {network_label} swap executed! Tx hash: {tx_hash.hex()}")
            log_event(f"🔁 {network_label} swap tx: {tx_hash.hex()}", "logs/bot.log")
        except Exception as e:
            err_msg = f"❌ Error during swap execution: {str(e)}"
            print(err_msg)
            log_event(err_msg, "logs/bot.log")
    else:
        print("❌ Condition not met. Swap aborted.")

# -----------------------------
# 🔃 Entry Point
# -----------------------------
if __name__ == "__main__":
    main()