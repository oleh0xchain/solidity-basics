// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.28;

contract Basics {

   bool public amIGay = false; 
   bool public isUserPoor; 

   bool public x = true;
   bool public y = false; 

   bool public z = (!x);
   bool public v = (!y);
   bool public b = (x || y); 
   bool public n = (x && y); 
}
