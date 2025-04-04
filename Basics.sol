// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.28;

contract Basics {

   uint public counter; 

   function setCounter (uint256 _count) public{
      counter = _count;
   } 
   
   function increment() public {
      counter += 1; 
   }

   function decrement () public{
      counter-=1; 
   }

   function math () public{
      counter = counter / 2; 
   }

}
