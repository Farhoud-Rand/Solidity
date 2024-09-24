// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";
contract Counter {
    // Storage variables are stored in a contract's permanent data storage on the blockchain. 
    // When you modify a storage variable in a transaction, the updated value becomes 
    // globally accessible for subsequent reads and interactions.
    // Storage variable (state variable) are persistent {last from transaction to transaction}
    // We save state variable in Storage slot starting from 0x0 address 
    // Value Types
    uint8 a =255;   // 0 -> 255 || address: 0x0
    uint256 b = 22; // alias: uint || address: 0x1

    int8 c = 127;   // -128 -> 127 || address: 0x2
    int256 d = -55; // alias: int256 || address: 0x3

    // Get the max value 
    uint e = type(uint).max;

    // Get the min value 
    int f = type(int).min;

    bool myCondition = true;

    // Define a set of options for a value by a name
    // enums can be translated to uint8 based on their position
    // the first option is 0, then 1, 2, 3 etc...
    enum Choice {
        Up,
        Down,
        Left,
        Right
    }

    Choice choice = Choice.Up;

    // Constants are stored directly in the bytecode of the contract rather than in storage or memoryin not in storage slot (because they are fixed)
    // Note: we should give it a value in initialization 
    int public constant x = 77;

    constructor() {
        // a += 1;  // This will make "a" overflow so we will get an error 
        
        // Use unchecked block
        unchecked {   // The unchecked block disables overflow and underflow checks (this means if we will not check them so it will not throw an error) this is used for gas optimization !
            a += 1;  // This will make "a" overflow so we will get an error 
        }

        // Now after 255 + 1 = 1 0000 0000 which will be 0 so if we print "a" it will print 0
        console.log(a);
        console.log(e); 
        console.log(f); 
        console.logBytes32(bytes32(e)); // Print the number in 32 byte

        if(myCondition){
            console.log("true codition"); 
        }

        if(choice == Choice.Up){
            console.log("Up");
        }
    }

    // To pass parameter to our counstrutor we need to pass it in the unit test object and in the script file
    // constructor(Choice choice) {
    //     if(choice == Choice.Up){
    //         console.log("Up");
    //     } else if (choice == Choice.Down){
    //         console.log("Down");
    //     }
    // }
}