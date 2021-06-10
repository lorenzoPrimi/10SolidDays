// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Timelock {
    address payable public owner;
    uint endDate;

    constructor(uint _endDate) payable {
        owner = payable(msg.sender);
        endDate = _endDate;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not owner.");
        _;
    }

    function deposit() onlyOwner public payable {
    }

    function withdraw() onlyOwner public {
        require(block.timestamp >= endDate, "You can't withdraw at this time.");
        uint amount = address(this).balance;
        (bool success,) = owner.call{value: amount}("");
        require(success, "Failure in sending ETH");
    }

}
