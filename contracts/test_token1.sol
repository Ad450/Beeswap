// SPDX-License-Identifier: Unilicense
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestToken1 is ERC20{
    constructor (uint256 _supply) ERC20 ("Test", "TT1"){
        _mint(msg.sender, _supply);
    }
}