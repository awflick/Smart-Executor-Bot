# Smart Executor Bot

A Python + Solidity project that automatically executes Uniswap V3 swaps based on real-time conditions. Built for use with mainnet or forked testing environments like Anvil.

---

## Overview

This bot monitors a condition (e.g. ETH price > $2500) and triggers a swap from one ERC-20 token to another using a deployed `SwapExecutor` smart contract on Uniswap V3.

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
```
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

