// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";
// =================================================
// Message Calls
// =================================================
// In this example we will try to send an ether form contract A to B
// So contract A should use .call function and contract B should have a receive function
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
