//SPDX-License-Identifier : MIT
pragma solidity ^0.6.6;
import "@uniswap/v2-periphery/contracts/UniswapV2Router02.sol";


contract BeeswapV2{
    // uniswap v2 router
     address payable private router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
     address private DAI =0xc7AD46e0b8a400Bb3C915120d284AafbA8fc4735;
     address private weth = 0xc778417E063141139Fce010982780140Aa0cD5Ab;


    function swapEthForTokens() external  payable returns (uint256[] memory amountsOut){
        
        require(msg.value <= address(msg.sender).balance && msg.value > 0, "insufficient balance");
       
        address[] memory path = new address[](2);
        path[0] = weth;
        path[1] = DAI;

       amountsOut = UniswapV2Router02(router).swapExactETHForTokens{value : msg.value}(0, path, msg.sender, block.timestamp);
       return amountsOut;
    }

    function swapTokensForETH(uint _amount) external payable returns (uint256[] memory) {
        require(_amount <= IERC20(DAI).balanceOf(msg.sender), "insufficient balance");

        bool success = IERC20(DAI).transfer(address(this), _amount);
        require(success, "transfer from failed");

        bool approved = IERC20(DAI).approve(router, _amount);
        require(approved, "transfer from failed");

        address[] memory path = new address[](2);
        

        path[0] = DAI;
        path[1] = weth;

        uint256[] memory amountsOut = UniswapV2Router02(router).swapExactTokensForETH(_amount, 0, path, msg.sender, block.timestamp);

        return amountsOut;

    }

    

}