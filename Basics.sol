// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.28;

contract Basics {

   uint256[] public myTickets = [1, 2 ,33334343, 4352454365424325, 0];

   function addTicketToArray(uint256 _ticketNumber) public {
      myTickets.push(_ticketNumber);

   }
   
   function getAmountOfTickets() public view returns (uint256){
      return myTickets.length;
   }

   function getTicketsFromArray(uint256 _arrayNumber) public view returns(uint256){
      return myTickets[_arrayNumber]; 
   }

    function swapTicket(uint256 _arrayNumber, uint256 _ticket) public {
      myTickets[_arrayNumber] = _ticket;
   }

   function getNewTicketsPool(uint256[] memory _newArray) public payable{
      myTickets = _newArray; 
   } 

}
