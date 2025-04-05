// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.28;

contract vote{

    string[] public electors; 

    uint256 public maxVotes; 
    uint256 public electionTime; 

    mapping (address => bool) public userVotes; 
    mapping (uint256 => uint256) public numberOfVotes; 

    constructor(string[] memory _electors, uint256 _maxVotes, uint256 _electionTime){
        maxVotes = _maxVotes; 
        electionTime = _electionTime; 
        electors = _electors;
    }

    function toVote( uint256 _number) public{
        require(userVotes[msg.sender]==false, "Your address can't vote =(");
        require(_number < electors.length, "Elector does not exist");

        userVotes[msg.sender] = true; 
        numberOfVotes[_number] += 1;

    }
}