//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
pragma abicoder v2;

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";

contract Bee {
    
    // first get the tokens to swap
    address private constant ROUTER = 0xE592427A0AEce92De3Edee1F18E0157C05861564;

    // get address of LINK  and WETH tokens
    address private constant LINK = 0x01BE23585060835E02B77ef475b0Cc51aA1e0709;
    address private constant WETH = 0xc778417E063141139Fce010982780140Aa0cD5Ab;

    // implement swap functionality
    function swap(uint256 _amount)
        external
        payable
        returns (uint256 amountOut)
    {
        TransferHelper.safeTransferFrom(
            LINK,
            msg.sender,
            address(this),
            _amount
        );

        TransferHelper.safeApprove(LINK, ROUTER, _amount);

       
           ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: LINK,
                tokenOut: WETH,
                fee: 3000,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: _amount,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });


        (amountOut) = ISwapRouter(ROUTER).exactInputSingle(params);
        return amountOut;
    }
}
