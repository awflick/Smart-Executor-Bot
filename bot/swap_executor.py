# swap_executor.py

# This module contains the logic to execute a swap using the SwapExecutor contract.
# It requires the following environment variables to be set:
# - TOKEN_IN: Address of the input token (e.g., LINK)
# - TOKEN_OUT: Address of the output token (e.g., USDC)
# - RECIPIENT: Address of the recipient of the output token
# - SWAP_EXECUTOR: Address of the SwapExecutor contract
# - ANVIL_PRIVATE_KEY: Private key for the sender account
# Ensure that the sender account has sufficient balance of TOKEN_IN to perform the swap.    

from web3 import Web3
import time
from eth_account import Account

def execute_real_swap(w3, contract, private_key, token_in, token_out, recipient, pool_fee, amount_in_eth, min_out_eth):
    account = Account.from_key(private_key)
    nonce = w3.eth.get_transaction_count(account.address)

    # Convert to wei
    amount_in = Web3.to_wei(amount_in_eth, "ether")
    min_out = Web3.to_wei(min_out_eth, "ether") # Minimum amount of tokenOut
    # NOTE: In production, amountOutMin should be calculated dynamically
    # using slippage tolerance based on real-time price data.
    deadline = int(time.time()) + 3600

    print(f"⛽ Swap Amount: {Web3.from_wei(amount_in, 'ether')} ETH")

    # Build the transaction calling executeSwap(tokenIn, tokenOut, amountIn, minOut, recipient, deadline, poolFee)
    tx = contract.functions.executeSwap(
        token_in,
        token_out,
        amount_in,
        min_out,
        recipient,
        deadline,
        pool_fee
    ).build_transaction({
        "from": account.address,
        "nonce": nonce,
        "gasPrice": w3.eth.gas_price,
    })

    signed_tx = account.sign_transaction(tx)
    tx_hash = w3.eth.send_raw_transaction(signed_tx.rawTransaction)
    print(f"🔁 Swap triggered! Tx hash: {tx_hash.hex()}")
    return tx_hash
