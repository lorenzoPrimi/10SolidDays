// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ICO is Ownable {
    ERC20 private token;
    uint startDate;
    uint price;
    
    constructor(address _tokenAddr, uint _startDate, uint _price) {
        startDate = _startDate;
        price = _price;
        token = ERC20(_tokenAddr);
    }

    modifier saleStarted() {
        require(block.timestamp >= startDate, "Sale hasn't started yet.");
        _;
    }

    //Very simple function. Need to add all the ERC20 approve and send logic
    function buyTokens() payable external saleStarted {
        uint tot_amount = token.balanceOf(address(this));
        uint amount = price * msg.value;
	//TODO refund ETH in case of failure
        require(tot_amount > amount, "Not enough balance");
        token.transfer(msg.sender, amount);
    }

}

