// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Voting {
    address owner;
    uint endDate;
    mapping(address => bool) private voters;
    Options[] public options;

    struct Options {
        string name;
        int votes;
    }

    constructor(uint _endDate) {
        owner = msg.sender;
        endDate = _endDate;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not owner.");
        _;
    }
    
    modifier isActive() {
        require(block.timestamp <= endDate, "Voting is expired.");
        _;
    }

    modifier hasNotVoted() {
        require(!voters[msg.sender], "You have already voted.");
        _;
    }

    function vote(uint idx) public hasNotVoted isActive {
        require(options.length > idx, "Proposal does not exist.");
        voters[msg.sender] = true;
        options[idx].votes++;
    }
    
    function getProposal(uint idx) public view returns(string memory) {
        require(idx >= 0 && idx < options.length, "Proposal does not exist.");
        return options[idx].name;
    }
    
    function getTime() public view returns(uint) {
        return block.timestamp;
    }
    
    function addProposal(string calldata name) public onlyOwner {
        options.push(Options({
            name: name,
            votes: 0
        }));
    }
    
    function getWinner() public view returns(string memory) {
        require(block.timestamp >= endDate, "Voting is ongoing.");
        //TODO add checks for when two proposal have the same number of votes
        string memory winner;
        int256 maxVotes = -1;
        for (uint i = 0; i < options.length; ++i) {
            if (options[i].votes > maxVotes){
                winner = options[i].name;
                maxVotes = options[i].votes;
            }
        }
        return winner;
    }

}
