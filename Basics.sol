// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.28;

contract Basics {

   address public myAddress; 

   function setAddress () public {
      myAddress = msg.sender;
   }

   function sendMoney(address payable _to) public payable  {

      _to.transfer(msg.value);

   }

   function getBalance(address _address) public view returns (uint256){
      return _address.balance; 
   }

   function getAddress () public view returns (address){
      return myAddress;
   }



}
