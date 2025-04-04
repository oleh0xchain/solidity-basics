// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.28;

contract Basics {
   enum Skills {NOOB, ADVANCED, PRO}

   Skills public someoneSkills;

   function educate() public {
      someoneSkills = Skills.ADVANCED;
   } 

   function educateTo(uint256 _skillLevel) public{
      someoneSkills = Skills(_skillLevel); 
   } 

}
