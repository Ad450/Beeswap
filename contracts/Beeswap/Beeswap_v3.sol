//SPDX-License-Identifier: Unilicense
pragma solidity ^0.8.4;
pragma abicoder v2;
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";

contract BeeswapV3{
    // uniswap v3 IswapRouter
    address private constant ROUTER_V3 = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
   
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
    // Beeswap approves ISwapRouter to spend _amountIn. ie. perform the swap functionality with the said _amountIn
    function swapExactInput(uint256 _amountIn, address _token1, address _token2) external lock returns(uint256 _amountOut){

        TransferHelper.safeTransferFrom(_token1, msg.sender, address(this), _amountIn);
        
        TransferHelper.safeApprove(_token1, ROUTER_V3, _amountIn);
        
        ISwapRouter.ExactInputSingleParams memory _params = ISwapRouter.ExactInputSingleParams({
            tokenIn: _token1,
            tokenOut: _token2,
            fee: 3000,
            recipient: msg.sender,
            deadline: block.timestamp,
            amountIn: _amountIn,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });

        

       // uniswap exactInputSingle from swapRouter returns the maximum amount a trader could get
        // _amountOut = ISwapRouter(swapRouter).exactInputSingle(_params);
        // return _amountOut;

    }

    // exact output single swap
    function swapExactOutput(address token1, address token2, uint256 _amountInMaximum, uint256 _amountOut) external lock returns (uint256 _amountIn){
        TransferHelper.safeTransfer(token1, address(this), _amountInMaximum);
        TransferHelper.safeApprove(token1, address(ROUTER_V3), _amountInMaximum);


        // used by uniswap exactOutput 
        ISwapRouter.ExactOutputSingleParams memory _params =  ISwapRouter.ExactOutputSingleParams({
              tokenIn: token1,
                tokenOut: token2,
                fee: 3000,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountOut: _amountOut,
                amountInMaximum: _amountInMaximum,
                sqrtPriceLimitX96: 0
        });

        // call uniswap exactOutput to perform swapß
        // change to Iswap 
       _amountIn =ISwapRouter(ROUTER_V3).exactOutputSingle(_params);

       // check if all tokens supplied were spent in the trade
       if(_amountInMaximum > _amountIn){
           TransferHelper.safeApprove(token1, ROUTER_V3, 0);
           TransferHelper.safeTransfer(token1, msg.sender, _amountInMaximum - _amountIn);
       }

       return _amountIn;
    }


}
