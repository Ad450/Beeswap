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
    ISwapRouter private immutable swapRouter;
    address private immutable token1;
    address private immutable token2;
    // uniswap V2
    address private constant V2ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    uint256 private immutable minimumAmountOut;
    uint24 private immutable poolFee;


    // uniswap v3 router
    // solidity prevents reading immutable (final) before initialization
    //address private immutable router;
    

    constructor (ISwapRouter _router, address _token1, address _token2, uint256 _minimumAmountOut, uint24 _poolFee) {
        require(_token1 != address(0), "invalid address");
        require(_token2 != address(0), "invalid address");
        
        swapRouter = _router;
        token1 = _token1;
        token2 = _token2;
        minimumAmountOut = _minimumAmountOut;
        poolFee = _poolFee;

        // testing
        console.log("contract deployed successfully");
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
    // Beeswap approves ISwapRouter to spend _amountIn. ie. perform the swap functionality with the said _amountIn
    function swapExactInput(uint256 _amountIn, address _token1, address _token2) external lock returns(uint256 _amountOut){

        TransferHelper.safeTransferFrom(_token1, msg.sender, address(this), _amountIn);
        
        TransferHelper.safeApprove(_token1, address(swapRouter), _amountIn);
        
        ISwapRouter.ExactInputSingleParams memory _params = ISwapRouter.ExactInputSingleParams({
            tokenIn: _token1,
            tokenOut: _token2,
            fee: poolFee,
            recipient: msg.sender,
            deadline: block.timestamp,
            amountIn: _amountIn,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });

        

       // uniswap exactInputSingle from swapRouter returns the maximum amount a trader could get
        // _amountOut = swapRouter.exactInputSingle(_params);
        // return _amountOut;

    }

    // exact output single swap
    function swapExactOutput(uint256 _amountInMaximum, uint256 _amountOut) external lock returns (uint256 _amountIn){
        TransferHelper.safeTransfer(token1, address(this), _amountInMaximum);
        TransferHelper.safeApprove(token1, address(swapRouter), _amountInMaximum);


        // used by uniswap exactOutput 
        ISwapRouter.ExactOutputSingleParams memory _params =  ISwapRouter.ExactOutputSingleParams({
              tokenIn: token1,
                tokenOut: token2,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountOut: _amountOut,
                amountInMaximum: _amountInMaximum,
                sqrtPriceLimitX96: 0
        });

        // call uniswap exactOutput to perform swapß
        // change to Iswap 
       _amountIn = swapRouter.exactOutputSingle(_params);

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

   function swapTokensForTokens(uint256 _amountIn) external  returns (uint256[] memory amounts){

        TransferHelper.safeTransferFrom(token1, msg.sender, address(this), _amountIn);
        console.log(" token 1 balance of Beeswap is", IERC20(token1).balanceOf(address(this)));
            
        TransferHelper.safeApprove(token1, address(swapRouter), _amountIn);


        //(address weth) =  IV2Router(V2ROUTER).WETH();

        address[] memory path = new address[](3);
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

}