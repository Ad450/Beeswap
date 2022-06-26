//SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

import "@uniswap/v2-periphery/contracts/UniswapV2Router02.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract V2Example{
    address  payable private router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    
    function swapTokensToETH(uint256 _amount, address tokenIn) external payable  returns (uint[] memory) {
    (bool success) = IERC20(tokenIn).transferFrom(msg.sender, address(this), _amount);
    require(success, "transfered failed");

    (bool approved) = IERC20(tokenIn).approve(router, _amount);
    require(approved, "approval failed");

     address[] memory path = new address[](2);
     address weth  = _getWethAddress();

     path[0] = tokenIn;
     path[1] = weth;
     (uint[] memory amountsOut)  =  UniswapV2Router02(router).swapExactTokensForETH(_amount, 0, path, msg.sender, block.timestamp);
     return amountsOut;
 }

    function _getWethAddress () private returns (address) {
      address weth =  UniswapV2Router02(router).WETH();
      return weth;
 }   
}