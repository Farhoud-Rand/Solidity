// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";
// =================================================
// Revert transaction
// =================================================
// REVERT
// no state changes should have occured
// no value should have been transferred
// gas will still be paid for
contract A {
    address b;
    // This variable to handle number of errors 
    uint256 public errorsCount = 0;

    constructor(address _b) {
        b = _b;
    }

    function callB() external payable {
        // To call the recive function in B contract (send value wtihout data)
        // Retruns from the call function:
        // 1) boolean value to indicate if the transaction revert or not
        // 2) Return data which will identify the custom error, by its signature (4 bytes)
        // Note this value (1 ether in the call function) will be taken from A balance 
        (bool success, bytes memory returnData) = b.call{value: 1 ether}("");
        // Check if there is an error or not 
        // If B revert then A still can make state changes(before or after the revert)
        if (!success) {
            console.logBytes(returnData); // 4 bytes = 8 hexdecimal character 
            // RetunData is the same of the first 4 bytes of the ouput of keccak256 function
            // keccak256 is a hash function that genarate 32 bytes uniquely 
            console.logBytes32(keccak256("DoNotPayMe(uint256)"));
            errorsCount++;
        }
    }
}

contract B {
    // This variable to test changing in state variable when B revert
    // If B revert and we try to read x then it will be 0, if not then any changes will be saved (so x = 15)
    uint256 public x = 0;
    // @notice nobody should ever pay this contract
    // 4 byte to identify each custom error 
    // We can make this error have an argument 
    // If we add argument then the 4 bytes will change to be the output of keccak256("DoNotPayMe(uint256)")
    // Like in this customer error we can specify the amount that other try to pay it to me
    // error DoNotPayMe();
    error DoNotPayMe(uint256);

    receive() external payable {
        // using Require 
        // require(false, "No one should pay me!");
        // using Revert + custom error 
        x = 15;
        revert DoNotPayMe(msg.value);
    }
}
