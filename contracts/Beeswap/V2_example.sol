//SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

import "@uniswap/v2-periphery/contracts/UniswapV2Router02.sol";



contract V2Example{
    address  payable private router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    
    function swapTokensToETH(uint256 _amount, address tokenIn) external payable  returns (uint[] memory) {
   
        // TransferHelper.safeTransferFrom(tokenIn, msg.sender, address(this), _amount);
        
        // TransferHelper.safeApprove(tokenIn, router, _amount);

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




// interface IERC20{
//     function approve(address spender, uint256 amount) external returns (bool);
//     function transferFrom(
//         address from,
//         address to,
//         uint256 amount
//     ) external returns (bool);

// }