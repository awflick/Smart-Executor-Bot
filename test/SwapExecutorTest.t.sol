// SPDX-License-Identifier: MIT

// NEED TO UPDATE V2 ROUTER TO V3 ROUTER

pragma solidity ^0.8.25;

import {Test} from "forge-std/Test.sol";
import {SwapExecutor} from "../src/SwapExecutor.sol";

interface IERC20 {
    function balanceOf(address) external view returns (uint256);
    function approve(address, uint256) external returns (bool);
    function transfer(address, uint256) external returns (bool);
}

contract SwapExecutorTest is Test {
    SwapExecutor executor;
    address owner;
    address router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Uniswap V2 Router
    address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // WETH address
    address dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F; // DAI address
    address recipient = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266; // Dummy Anvil recipient address

    function setUp() public {
        owner = address(this); // Set the owner to this contract for testing
        vm.createSelectFork(vm.envString("MAINNET_RPC_URL")); // Create a fork of the mainnet for testing

        executor = new SwapExecutor(router, weth);

        vm.deal(owner, 10 ether); // Fund the owner with 10 ETH
    }

    function testSwapWETHToDAI() public {
        // Convert 1 ETH to WETH so we actually have tokenIn
        (bool success, ) = weth.call{value: 1 ether}(
            abi.encodeWithSignature("deposit()")
        );
        require(success, "WETH deposit failed");
        // Approve the SwapExecutor to spend WETH
        IERC20(weth).approve(address(executor), type(uint256).max);

        // Check initial balances
        uint256 initialWETHBalance = IERC20(weth).balanceOf(owner);
        uint256 initialDAIBalance = IERC20(dai).balanceOf(recipient);

        // Set a realistic minimum output (e.g., 0.0005 ETH worth of DAI)
        uint256 amountOutMin = 1e18 / 2000;

        // Execute the swap
        executor.executeSwap(
            weth, // Input toeken (WETH)
            dai, // Output token (DAI)
            1 ether, // Amount to swap (1 WETH)
            amountOutMin, // Minimum amount out 
            recipient, // Recipient of the output tokens
            block.timestamp + 1 hours, // Deadline (1 hour from now)
            3000 // Pool fee for Uniswap V3 (0.3%)
        );

        // Check final balances
        uint256 finalWETHBalance = IERC20(weth).balanceOf(owner);
        uint256 finalDAIBalance = IERC20(dai).balanceOf(recipient);

        // Assert that the WETH balance has decreased by 1 WETH
        assertEq(finalWETHBalance, initialWETHBalance - 1 ether, "WETH balance should decrease by 1 WETH");

        // Assert that the DAI balance has increased (we can't check exact amount due to slippage)
        assertGt(finalDAIBalance, initialDAIBalance, "DAI balance should increase after swap");

        // Emit an event to indicate the swap was executed
        emit log_named_address("Swap executed from WETH to DAI", recipient);
        emit log_named_uint("Initial WETH Balance", initialWETHBalance);
        emit log_named_uint("Final WETH Balance", finalWETHBalance);
        emit log_named_uint("Initial DAI Balance", initialDAIBalance);
        emit log_named_uint("Final DAI Balance", finalDAIBalance);
        emit log("SwapExecutorTest: testSwapWETHToDAI executed successfully"); 
    }

}
