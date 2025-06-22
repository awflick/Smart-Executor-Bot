# Smart Executor Bot

![Built with Foundry](https://img.shields.io/badge/Built%20with-Foundry-blueviolet)
![Web3.py](https://img.shields.io/badge/Python-Web3.py-informational)

A Python + Solidity project that automatically executes Uniswap V3 swaps based on real-time conditions. Built for use with mainnet or forked testing environments like Anvil.

---

## Overview

This bot monitors a condition (e.g. ETH price > $2000) and triggers a swap from one ERC-20 token to another using a deployed `SwapExecutor` smart contract on Uniswap V3.

---

## Stack

- **Solidity**: Smart contract (`SwapExecutor.sol`) uses `ISwapRouter.exactInputSingle` for token swaps.
- **Python (Web3.py)**: Handles price checks, contract interaction, and swap logic.
- **Foundry**: Used for compiling, deploying, testing (`forge`, `anvil`, `makefile` driven).
- **Coingecko API**: For ETH price checking.
- **.env Config**: Fully environment-driven for clean switching between local and Sepolia.

---

## Important Notes

- **This bot only works in Anvil mainnet fork mode or on a real testnet.**  
  Local Anvil without a fork does not have Uniswap V3 contracts or liquidity.

- Use the included Makefile to run everything step by step.

---

## Getting Started

### 1. Clone & Set Up

```
git clone https://github.com/your-username/smart-executor-bot.git
cd smart-executor-bot
python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
```

### 2. Configure `.env`

```dotenv

# Required for forked/mainnet deployments
ANVIL_RPC_URL=http://127.0.0.1:8545
ANVIL_PRIVATE_KEY=0x...

# Token addresses (use mainnet addresses)
TOKEN_IN=0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2  # WETH
TOKEN_OUT=0x6B175474E89094C44Da98b954EedeAC495271d0F  # DAI
UNISWAP_V3_ROUTER=0xE592427A0AEce92De3Edee1F18E0157C05861564

# Will be updated with each deployment
SWAP_EXECUTOR=0x...

RECIPIENT=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
LIVE_MODE=false
```

### 3. Run Anvil in Fork Mode

```
make anvil-fork
```

> Requires \`MAINNET_RPC_URL\` in \`.env\` to be set with an Alchemy or Infura URL.

### 4. Deploy Contract

```
make deploy-anvil
```

Copy the deployed address into your \`.env\` under \`SWAP_EXECUTOR\`.

### 5. Run the Bot

```
make run-anvil
```
#### Example Output:

```
🔍 Running in ANVIL (Local) mode
RPC_URL: http://127.0.0.1:8545
Using Private Key: ANVIL
Bot initialized
🔑 Account loaded: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
Account balance: 9999999837077049077392 wei
Current ETH Price: $2180.36
✅ Condition met! (ETH > $2000) — Ready to trigger swap
🧪 SWAP DEBUG
Token In: 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
Token Out: 0x6B175474E89094C44Da98b954EedeAC495271d0F
Router: 0xC7f2Cf4845C6db0e1a1e91ED41Bcd0FcC1b0E141
⛽ Swap Amount: 1 ETH
🔁 Swap triggered! Tx hash: 0xf9af907a63682b0e9ae5134a4e38b266f4401ae6c62b8d5ea27da759f843df7b
🔁 ANVIL swap executed! Tx hash: 0xf9af907a63682b0e9ae5134a4e38b266f4401ae6c62b8d5ea27da759f843df7b
```

---

## Project Structure

```
.
├── bot/
│   ├── trigger_bot.py
│   ├── swap_executor.py
│   └── utils/
│       ├── load_abi.py
│       └── logger.py
├── script/
│   └── Deploy.s.sol
├── src/
│   └── SwapExecutor.sol
├── test/
│   └── SwapExecutorTest.t.sol
├── .env
├── Makefile
├── requirements.txt
└── README.md
```


---

## Clean Up

To remove build artifacts:

```
make clean
```

---

## Status

- [x] Anvil + Mainnet Fork tested  
- [x] Swaps working via Uniswap V3  
- [x] Dynamic \`.env\` config  
- [x] GitHub push-ready  

---

## Future Additions

- [ ] Frontend for config toggling  
- [ ] Multi-token pair execution  

---

Built by [Adam Flick](https://github.com/awflick)

