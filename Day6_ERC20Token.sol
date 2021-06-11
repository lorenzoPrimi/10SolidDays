@@ -0,0 +1,49 @@
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract ERC20Token {
    uint public totalSupply;
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    constructor(string memory tokenName, string memory tokenSymbol, uint initialSupply) {
        totalSupply = initialSupply*10**uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        name = tokenName;
        symbol = tokenSymbol;
    }
    
    function _transfer (address _from, address _to, uint256 _value) internal {
        require(_to != address(0));
        require(balanceOf[_from] >= _value, "You don't have enough balance.");
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
    }

    function transfer (address _to, uint256 _value) public returns (bool success) {
        _transfer(msg.sender, _to, _value);
        return true;
    }
    
    function transferFrom (address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender], "Not enough allowance.");
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }
    
    function approve (address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] += _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
}
