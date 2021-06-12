//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WhiteElephantGame is Ownable {
    mapping(address => uint256) private balances;
    ERC20 private ERC20interface;

    constructor() {
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function approve(address tokenAdress, uint256 _amount) external onlyOwner returns (bool) {
        ERC20interface = ERC20(tokenAdress);
        emit Approval(msg.sender, address(this), _amount);
        return ERC20interface.approve(address(this), _amount);
    }

    //This function transfer ERC20 tokens from the owner to the smart contract balance.
    function depositTokens(address tokenAddress, uint256 _amount) external onlyOwner payable {
        ERC20interface = ERC20(tokenAddress);
        address from = msg.sender;
        address to = address(this);
        ERC20interface.transferFrom(from, to, _amount);
        balances[tokenAddress] += _amount;
        emit Transfer(msg.sender, to, _amount);
    }
    
    //This function transfer ERC20 tokens from the owner to another person after approval.
    function transferTokens(address tokenAddress, uint256 _amount, address _to) external onlyOwner payable {
        ERC20interface = ERC20(tokenAddress);
        address from = msg.sender;
        ERC20interface.transferFrom(from, _to, _amount);
        emit Transfer(msg.sender, _to, _amount);
    }

    //This function transfer ERC20 tokens the smart contract balance to the recipient.
    function sendTokens(address tokenAddress, uint256 _amount, address _to) external onlyOwner {
        require(balances[tokenAddress] >= _amount, "Balance not enough.");
        ERC20interface = ERC20(tokenAddress);
        address from = address(this);
        ERC20interface.transferFrom(from, _to, _amount);
        balances[tokenAddress] -= _amount;
        emit Transfer(msg.sender, _to, _amount);
    }

    function checkBalance(address tokenAddress) external view onlyOwner returns (uint256) {
        return balances[tokenAddress];
    }

}
