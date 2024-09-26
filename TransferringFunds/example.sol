// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";

contract Contract {
    address owner;
    address public a;
    address public b;
    
    constructor(address _a, address _b) {
        owner = msg.sender;
        a = _a;
        b = _b;
    }

    function payA() public payable {
        (bool s, ) = a.call{ value: msg.value }("");
        require(s);
    }

    function payB() public payable {
        (bool s, ) = b.call{ value: msg.value }("");
        require(s);
    }

    receive() external payable{}

    function tip() external payable{
        require(msg.value > 0, "No Ether sent");

        // Send Ether to the owner
        (bool success, ) = owner.call{value: msg.value}("");
        require(success, "Transfer to owner failed");
    }
}

contract A {
    address b;
    // We should make the constructor payable to receive ether
    constructor(address _b) payable {
        b = _b;
        console.log("Contract A revice this number of Ether = " , msg.value);
        console.log("Balance of A = " , address(this).balance);
    }

    // This function will be called in the test 
    function payHalf() external {
        // Get the half of the balance of contract A, in order to send it to contract B
        (bool success,) = b.call {value : (address(this).balance)/ 2} ("");    
        require(success);
    }
}

contract B {
    // We can keep track for payers 
    address mostRecentPayer;

    receive() external payable {
        mostRecentPayer = msg.sender;
        console.log("Balance of B = " , address(this).balance);
    } 
}
