//SPDX-License-Identifier: Unilicense
pragma solidity ^0.8.4;
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "@uniswap/sdk";

contract Beeswap{
    ISwapRouter private immutable swapRouter;
    address private immutable token1;
    address private immutable token2;
    uint256 private immutable minimumAmountOut;
    uint24 private immutable poolFee;

    constructor (ISwapRouter _router, address _token1, address _token2, uint256 _minimumAmountOut, uint24 _poolFee) {
        require(address != address(0), "invalid address");
        require(address != address(0), "invalid address");
        
        swapRouter = _router;
        token1 = _token1;
        token2 = _token2;
        minimumAmountOut = _minimumAmountOut;
        poolFee = _poolFee;
    }

    // reentracy lock
    bool private locked = false;
    modifier lock(){
        require(!locked, "contract lockde");
        locked = true;
        _;
        locked = false;
    }

    // Single swaps

    // caller approves Beeswap to withdraw _amountIn from their account
    // Beeswap approves ISwapRouter to spend _amountIn. ie. perform the swap functionality
    function swapExactInput(uint256 _amountIn) external lock returns(uint256 _amountOut){
        // Caller approves withdrawal - will be done by the wallets after calling transfer
        TransferHelper.safeTransfer(token1, address(this), _amountIn);

        // approve ISwapRouter to use the _amountIn for the swap
        TransferHelper.safeApprove(token1, address(swapRouter), _amount);

        // get exactInput params from uniswap
        swapRouter.ExactInputSingleParams memory _params = swapRouter.ExactInputSingleParams({
            tokenIn: token0,
            tokenOut: token1,
            fee: poolFee,
            recipient: msg.sender,
            deadline: block.timestamp,
            amountIn: _amountIn,
            amountOutMinimum: minimumAmountOut,
              sqrtPriceLimitX96: 0
        });

        // uniswap exactInputSingle from swapRouter returns the maximum amount a trader could get
        _amountOut = swapRouter.exactInputSingle(_params);

    }

    // exact output single swap
    function swapExactOutput(uint256 _amountInMaximum, uint256 _amountOut) external lock returns (uint256 _amountIn){
        TransferHelper.safeTransfer(token1, address(this), _amountInMaximum);
        TransferHelper.safeApprove(token1, address(swapRouter), _amountInMaximum);


        // used by uniswap exactOutput 
        swapRouter.ExactOutputSingleParams memory _params =   swapRouter.ExactOutputSingleParams({
              tokenIn: token0,
                tokenOut: token1,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountOut: _amountOut,
                amountInMaximum: _amountInMaximum,
                sqrtPriceLimitX96: 0
        });

        // call uniswap exactOutput to perform swapß
       _amountIn = swapRouter.exactOutputSingle(_params);

       // check if all tokens supplied were spent in trade
       if(_amountInMaximum > _amountIn){
           TransferHelper.safeApprove(token1, address(swapRouter), 0);
           TransferHelper.safeTransfer(token1, msg.sender, _amountInMaximum - _amountIn);
       }
    }

   
}