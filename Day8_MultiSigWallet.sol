// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract MultiSigWallet {
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public numConfirmationsRequired;
    Transaction[] public transactions;
    
    struct Transaction {
        address to;
        uint amount;
        uint votes;
        mapping(address => bool) voters;
        bool executed;
    }
    
    //TODO add events
    //For a better implementation look at: https://solidity-by-example.org/app/multi-sig-wallet/
    
    constructor(address[] memory _owners, uint _numConfirmationsRequired) payable {
        require(_owners.length > 0, "Num of owners should be > 0");
        require(
            _numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length,
            "invalid number of required confirmations"
        );
        numConfirmationsRequired = _numConfirmationsRequired;
        for (uint i; i< _owners.length;i++){
            isOwner[_owners[i]] = true;
            owners.push(_owners[i]);
        }
    }
    
    modifier onlyOwner() {
        require(isOwner[msg.sender], "Caller is not owner");
        _;
    }
    
    function deposit() public payable {
    }

    function submitTransaction(address _to, uint _amount) onlyOwner public {
        uint currentIdx = transactions.length;
        Transaction storage t = transactions[currentIdx];
        t.to = _to;
        t.amount = _amount;
        t.executed = false;
        t.votes = 0;
    }
    
    function approveTransaction(uint idx) onlyOwner public {
        require(transactions.length <= idx, "Invalid transaction");
        Transaction storage transaction = transactions[idx];
        require(transaction.executed == false, "Already executed");
        require(transaction.voters[msg.sender] == false , "Already voted");
        transaction.voters[msg.sender] = true;
        transaction.votes++;
    }
    
    function getTransaction(uint idx) public view
        returns (address to, uint amount, uint votes, bool executed)
    {
        Transaction storage transaction = transactions[idx];
        return (
            transaction.to,
            transaction.amount,
            transaction.votes,
            transaction.executed
        );
    }

    function sendTransaction(uint idx) onlyOwner public {
        require(transactions.length <= idx, "Invalid transaction");
        Transaction storage transaction = transactions[idx];
        require(transaction.executed == false, "Already executed");
        require(transaction.votes >= numConfirmationsRequired, "Not enough confirmations");
        uint amount = address(this).balance;
        require(amount >= transaction.amount, "Not enough balance");
        (bool success,) = transaction.to.call{value: transaction.amount}("");
        require(success, "Failure in sending ETH");
    }
    
}

