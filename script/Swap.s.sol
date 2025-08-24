// SPDX-License-Identifier: MIT 

//Swap.s.sol
// This script is used to execute a swap using the SwapExecutor contract.
// It requires the following environment variables to be set:
// - TOKEN_IN: Address of the input token (e.g., LINK)
// - TOKEN_OUT: Address of the output token (e.g., USDC)
// - RECIPIENT: Address of the recipient of the output token
// - SWAP_EXECUTOR: Address of the SwapExecutor contract
// - ANVIL_PRIVATE_KEY: Private key for the sender account
// Ensure that the sender account has sufficient balance of TOKEN_IN to perform the swap.
// Ensure that the SwapExecutor contract is deployed and configured correctly.

pragma solidity ^0.8.25;

import {Script} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SwapExecutor} from "../src/SwapExecutor.sol";

/**
 * @notice This script executes a swap using the SwapExecutor contract.
 * It assumes the existence of a Uniswap V2 router and WETH address.
 */
contract Swap is Script {
    function run() external {
        address token_in = vm.envAddress("TOKEN_IN");  
        address token_out = vm.envAddress("TOKEN_OUT"); 
        address recipient = vm.envAddress("RECIPIENT"); 
        address swapExecutor = vm.envAddress("SWAP_EXECUTOR"); 
        uint256 privateKey = vm.envUint("ANVIL_PRIVATE_KEY"); 
        address sender = vm.addr(privateKey);

        // Fund the account with 100 ether for gas and token swaps
        vm.deal(sender, 100 ether); 

        // 2. Fund sender with LINK (1e18 = 1 LINK)
        IERC20(token_in).transfer(sender, 1e18);  // Requires LINK balance in sender contract

        // Start broadcasting
        vm.startBroadcast(privateKey);

        // Create an instance of the SwapExecutor contract
        SwapExecutor executor = SwapExecutor(payable(swapExecutor));
        
        // Execute the swap
        executor.executeSwap(
            token_in,
            token_out,
            1e18,                // Amount of LINK to swap
            1e6,                 // minOut (1 USDC)
            recipient,
            block.timestamp + 3600,
            3000                 // Pool fee tier
        );

        // Stop broadcasting
        vm.stopBroadcast();
    }

}