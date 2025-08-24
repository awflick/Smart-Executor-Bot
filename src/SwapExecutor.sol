// SPDX-License-Identifier: MIT

// SwapExecutor.sol
// This contract is used to execute token swaps using Uniswap V3.   
// It requires the Uniswap V3 router and WETH address to be set during deployment.  
// The contract provides a function to execute swaps with specified parameters.

pragma solidity ^0.8.25;

import {ISwapRouter} from "@uniswap/v3-periphery/interfaces/ISwapRouter.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SwapExecutor {
    ISwapRouter public immutable swapRouter;
    address public immutable WETH;

    constructor(address _swapRouter, address _weth) {
        swapRouter = ISwapRouter(_swapRouter);
        WETH = _weth;
    }

    /**
     * @notice Executes a token swap using Uniswap V3.
     * @param tokenIn The address of the token to swap from (e.g., WETH).
     * @param tokenOut The address of the token to receive (e.g., DAI).
     * @param amountIn The exact amount of tokenIn to swap.
     * @param amountOutMin The minimum amount of tokenOut to receive.
     * @param recipient The address to receive the output token.
     * @param deadline The Unix timestamp after which the trade is invalid.
     * @param poolFee The Uniswap V3 fee tier (e.g., 500, 3000, or 10000).
     * @return success True if the swap was successful.
     */
    function executeSwap(
        address tokenIn,
        address tokenOut,
        uint256 amountIn,
        uint256 amountOutMin,
        address recipient,
        uint256 deadline,
        uint24 poolFee
    ) external returns (bool success) {
        require(
            tokenIn != address(0) && tokenOut != address(0),
            "Invalid token"
        );
        require(amountIn > 0, "Invalid amount");

        uint256 balance = IERC20(tokenIn).balanceOf(address(this));
        require(balance >= amountIn, "Insufficient tokenIn balance");

        bool approved = IERC20(tokenIn).approve(address(swapRouter), amountIn);
        require(approved, "Approval failed");

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: tokenIn,
                tokenOut: tokenOut,
                fee: poolFee,
                recipient: recipient,
                deadline: deadline,
                amountIn: amountIn,
                amountOutMinimum: amountOutMin,// WARNING: should be calculated dynamically for slippage protection
                sqrtPriceLimitX96: 0
            });

        uint256 amountOut = swapRouter.exactInputSingle(params);
        return amountOut >= amountOutMin;
    }
}
