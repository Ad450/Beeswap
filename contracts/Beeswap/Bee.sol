//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "./V2Router.sol";


contract Bee { 
    address private constant ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    function swap(uint256 _amountIn)  public {
        TransferHelper.safeTransferFrom(DAI,msg.sender, address(this), _amountIn);
        TransferHelper.safeApprove(DAI, address(ROUTER), _amountIn);


        (address weth) =  IV2Router(ROUTER).WETH();

        address[] memory path = new address[](3);
        path[0] = DAI;
        path[1] = weth;
        

        IV2Router(ROUTER).swapExactTokensForTokens(_amountIn, 1, path, msg.sender, block.timestamp);
    }

    function swapETHforTokens(uint256 _amountIn) public {
        TransferHelper.safeTransferFrom(DAI,msg.sender, address(this), _amountIn);
        TransferHelper.safeApprove(DAI, address(ROUTER), _amountIn);


        (address weth) =  IV2Router(ROUTER).WETH();

        address[] memory path = new address[](3);
        path[0] = DAI;
        path[1] = weth;
        

        IV2Router(ROUTER).swapExactETHForTokens( 1, path, msg.sender, block.timestamp);
    }
}