// SPDX-License-Identifier: MIT

// Deploy.s.sol

// This script deploys the SwapExecutor contract.
// It requires the following environment variables to be set:
// - UNISWAP_V3_ROUTER: Address of the Uniswap V3 router
// - TOKEN_IN: Address of the input token (e.g., WETH)
// The script will deploy the SwapExecutor contract and log its address.

pragma solidity ^0.8.25;

import {Script, console} from "forge-std/Script.sol";
import {SwapExecutor} from "../src/SwapExecutor.sol";

contract DeployScript is Script {
    function run() external {
        address router = vm.envAddress("UNISWAP_V3_ROUTER");
        address weth = vm.envAddress("TOKEN_IN");

        vm.startBroadcast(); // <-- start first
        SwapExecutor swapExecutor = new SwapExecutor(router, weth); // <-- deploy now
        vm.stopBroadcast();

        console.log(unicode"✅ SwapExecutor deployed at:", address(swapExecutor));
    }
}
