// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.28;

contract Basics {
   
   mapping (address => uint256 ) public userBalances; 

   function deposit() public payable {
      userBalances[msg.sender] += msg.value; 
   }

   function addBalance(address _user, uint256 _balance) public{
      userBalances [_user] = _balance;
   } 

   function getBalance(address _user) public view returns (uint256){
      return userBalances[_user];
   }



}
