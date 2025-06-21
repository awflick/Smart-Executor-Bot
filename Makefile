# Makefile for Smart Executor Bot

# Environment file
export ENV_FILE?=.env

# Load .env variables inline for each target
include $(ENV_FILE)

# ====== PYTHON BOT COMMANDS ======
run-anvil:
	@echo "Running bot against local Anvil fork..."
	python bot/trigger_bot.py

run-sepolia:
	@echo "Running bot against Sepolia testnet..."
	LIVE_MODE=true SEPOLIA_RPC_URL=${SEPOLIA_RPC_URL} python bot/trigger_bot.py

simulate:
	@echo "Simulating bot without sending transactions..."
	LIVE_MODE=false python bot/trigger_bot.py

run-sepolia-debug:
	@echo "Running bot against Sepolia testnet in DEBUG mode..."
	LIVE_MODE=true SEPOLIA_RPC_URL=${SEPOLIA_RPC_URL} python -X dev -Wd -v bot/trigger_bot.py

# ====== FOUNDRY DEPLOYMENT ======

anvil:
	@echo "Starting local Anvil node..."
	anvil

anvil-fork:
	@echo "Starting Anvil forked from mainnet..."
	source .env && \
	anvil --fork-url $$MAINNET_RPC_URL --fork-chain-id 1 --fork-block-number 19700000


deploy-anvil:
	@echo "Deploying contract to local Anvil node..."
	forge script script/Deploy.s.sol \
		--rpc-url ${ANVIL_RPC_URL} \
		--broadcast \
		--private-key ${ANVIL_PRIVATE_KEY} \

deploy-sepolia:
	@echo "Deploying contract to Sepolia..."
	@forge script script/Deploy.s.sol \
		--rpc-url ${SEPOLIA_RPC_URL} \
		--broadcast \
		--verify \
		--private-key ${METAMASK_PRIVATE_KEY} \
		--chain-id 11155111

verify-sepolia:
	@echo "Verifying contract on Sepolia..."
	forge verify-contract 0xE12a341599d8B5B61E56F2B5E8cF644C1E31C7ff src/SwapExecutor.sol:SwapExecutor --chain-id 11155111 --watch --etherscan-api-key ${ETHERSCAN_API_KEY}

# ====== CLEANUP ======
clean:
	@echo "Cleaning build artifacts..."
	rm -rf out cache logs/*.log broadcast/*/*.json

.PHONY: run-anvil run-sepolia simulate anvil deploy-anvil deploy-sepolia verify-sepolia clean