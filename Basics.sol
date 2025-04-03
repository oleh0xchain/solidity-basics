// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.28;

contract Basics {
    string public greetings = "Hello World!"; 
    string public name = "Oleh"; 
    string public surname = "Bielous"; 

    function getFullName() public view returns (string memory){
        return string(abi.encodePacked(name, " ", surname));
    }

    function setGreetings (string calldata message) external {
        greetings = message;
    }

    function getGreetings () public view returns (string memory){
        return greetings;
    }
}
