// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.28;

contract Basics {

  

   struct UserData {
      string name; 
      uint256 age; 
      bool isGay; 

   }
   mapping(address => UserData) public users;

   UserData public me; 

   function getUserName(address _userAddress) public view returns (string memory){
      return users[_userAddress].name; 
   }

   function getUserAge(address _userAddress) public view returns (uint256){
      return users[_userAddress].age; 
   }

   function getUserStatus(address _userAddress) public view returns (bool){
      return users[_userAddress].isGay; 
   }

   function setUserData (string memory _name, uint256 _age, bool _isGay) public {
      users[msg.sender] = UserData(_name, _age, _isGay); 
   }


   function setUserData1() public{
      me = UserData("Nick", 26, false);
   }

   function setUserData2() public {
      me = UserData({
         name: "Mike",
         age: 25,
         isGay: true
      });
   }

   function setUserData3() public{
      me.name = "Ivan"; 
      me.age = 54; 
      me.isGay = false; 
   }




}
