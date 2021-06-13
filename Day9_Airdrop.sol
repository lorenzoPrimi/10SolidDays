// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Airdrop is Ownable {
    ERC20 private token;
    mapping(address => uint256) private claim;
    uint amount = 100000000000000000000;

    constructor(address _tokenAddr) {
        token = ERC20(_tokenAddr);
    }
    
    //function where every user can claim tokens
    function getAirdrop() public {
        require(token.balanceOf(this) >= amount, "Balance not enough.");
        require(claim[msg.sender] == false, "Already claimed.");
        token.transfer(msg.sender, amount); //18 decimals token
        claim[msg.sender] = true;
    }

    //function to give airdrop to a set of addresses
    function payAirdrop(address[] memory _recipients, uint _amount) onlyOwner public {
        uint tot_amount = token.balanceOf(this);
        require(tot_amount > _amount*_recipients.length, "Not enough balance");
        for (uint256 i = 0; i < _recipients.length; ++i) {
            token.transfer(msg.sender, _amount);
        }
    }

}

