// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Storage {
    uint number;
    address owner;

    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner, "Caller is not owner.");
        _;
    }
    
    function getNumber() public view returns(uint) {
        return number;
    }
    
    function setNumber(uint _number) public onlyOwner {
        number = _number;
    }

}
