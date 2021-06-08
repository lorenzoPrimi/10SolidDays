// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract ETHWallet {
    address payable public owner;
    
    constructor() payable {
        owner = payable(msg.sender);
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not owner.");
        _;
    }

    function deposit() public payable {
    }

    function withdraw() onlyOwner public {
        uint amount = address(this).balance;
        (bool success,) = owner.call{value: amount}("");
        require(success, "Failure in sending ETH");
    }

    function transfer(address payable _to, uint _amount) onlyOwner public {
        (bool success,) = _to.call{value: _amount}("");
        require(success, "Failure in sending ETH");
    }
    
}

