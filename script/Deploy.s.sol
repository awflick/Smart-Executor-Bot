// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script, console} from "forge-std/Script.sol";
import {SwapExecutor} from "../src/SwapExecutor.sol";


contract DeployScript is Script {

    function run() external {
        // Read from your existing .env variables
        address router = vm.envAddress("UNISWAP_V3_ROUTER");
        address weth = vm.envAddress("TOKEN_IN");

        SwapExecutor swapExecutor = new SwapExecutor(router, weth);

        vm.startBroadcast();
        console.log("SwapExecutor deployed to:", address(swapExecutor));
        vm.stopBroadcast();

        console.log(unicode"✅ SwapExecutor deployed at:", address(swapExecutor));
    }
}