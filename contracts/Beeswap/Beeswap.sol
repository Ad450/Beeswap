//SPDX-License-Identifier: Unilicense
pragma solidity ^0.8.4;
pragma abicoder v2;
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


//import "@uniswap/v2-periphery/contracts/UniswapV2Router02.sol";
 import "./V2Router.sol";
import "hardhat/console.sol";

contract Beeswap{
    // uniswap v3 IswapRouter
    address private constant swapRouter = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
   
    // uniswap V2
    address private constant V2ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    


    // uniswap v3 router
    // solidity prevents reading immutable (final) before initialization
    //address private immutable router;
    


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
        
        TransferHelper.safeApprove(_token1, swapRouter, _amountIn);
        
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
        TransferHelper.safeApprove(token1, address(swapRouter), _amountInMaximum);


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
       _amountIn =ISwapRouter(swapRouter).exactOutputSingle(_params);

       // check if all tokens supplied were spent in the trade
       if(_amountInMaximum > _amountIn){
           TransferHelper.safeApprove(token1, address(swapRouter), 0);
           TransferHelper.safeTransfer(token1, msg.sender, _amountInMaximum - _amountIn);
       }

       return _amountIn;
    }


    //   function swapExactTokensForTokens(
    //   uint amountIn,
    //   uint amountOutMin,
    //   address[] calldata path,
    //   address to,
    //   uint deadline
    // ) external returns (uint[] memory amounts);

   function swapTokensForTokens(address token1, address token2, uint256 _amountIn) external  returns (uint256[] memory amounts){
        TransferHelper.safeTransferFrom(token1, msg.sender, address(this), _amountIn);
        
        TransferHelper.safeApprove(token1, address(swapRouter), _amountIn);

        //(address weth) =  IV2Router(V2ROUTER).WETH();

        address[] memory path = new address[](2);
        path[0] = token1;
        path[1] = token2;
       

        //IV2Router(router).swapExactTokensForTokens(_ amountIn, 0, path, msg.sender, block.timestamp);

     ( amounts) =  IV2Router(V2ROUTER).swapExactTokensForTokens(_amountIn, 1, path, msg.sender, block.timestamp);
     return amounts;
   }

    // testing 
    function testWeth() public returns (address weth){
           ( weth) =  IV2Router(V2ROUTER).WETH();
           return weth;
    }

    // testing
    function approve(uint _amount, address token) external{
       (bool approved) =  IERC20(token).approve(address(this), _amount);
       require(approved, "approval failed");
        console.log("approved");
    }
    

    // testing 
    function allowance(address spender, address token) external returns (uint256){
     (uint256 amount) =  IERC20(token).allowance(msg.sender, spender);
     return amount;
    }

}
