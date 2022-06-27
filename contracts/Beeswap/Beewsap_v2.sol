//SPDX-License-Identifier : MIT
pragma solidity ^0.6.6
import "@uniswap/v2-periphery/contracts/UniswapV2Router02.sol";


contract BeeswapV2{
     address payable private router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    function swapTokensToETH(uint256 _amount, address tokenIn)
        external
        payable
        returns (uint256[] memory)
    {
        bool success = IERC20(tokenIn).transfer(address(this), _amount);
        require(success, "transfer from failed");

        bool approved = IERC20(tokenIn).approve(router, _amount);
        require(approved, "transfer from failed");

        address[] memory path = new address[](2);
        address weth = 0xc778417E063141139Fce010982780140Aa0cD5Ab;

        path[0] = tokenIn;
        path[1] = weth;
        uint256[] memory amountsOut = UniswapV2Router02(router)
            .swapExactTokensForETH(
                _amount,
                0,
                path,
                msg.sender,
                block.timestamp
            );
        return amountsOut;
    }

    function getWethAddress() public returns (address) {
        address weth = UniswapV2Router02(router).WETH();
        return weth;
    }
}