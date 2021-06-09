// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract MultiSend {
    address payable public owner;
    address[] public employees;

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
    
    function addEmployees(address[] memory _employees) public onlyOwner {
        for (uint256 i = 0; i < _employees.length; ++i) {
            employees.push(_employees[i]);
        }
    }

    function payEmployees(uint _amount) onlyOwner public {
        uint tot_amount = address(this).balance;
        require(tot_amount > _amount*employees.length, "Not enough balance");
        for (uint256 i = 0; i < employees.length; ++i) {
            transfer(payable(employees[i]), _amount);
        }
    }

}

