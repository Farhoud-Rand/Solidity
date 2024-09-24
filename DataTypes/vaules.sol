// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";
contract Counter {
    // uint256 public number;

    // function setNumber(uint256 newNumber) public {
    //     number = newNumber;
    // }

    // function increment() public {
    //     number++;
    // }
    // =================================================
    // Value Types
    uint8 a =255;   // 0 -> 255
    uint256 b = 22; // alias: uint

    int8 c = 127;   // -128 -> 127
    int256 d = -55; // alias: int256

    // Get the max value 
    uint e = type(uint).max;

    // Get the min value 
    int f = type(int).min;

    bool myCondition = true;

    // Define a set of options for a value by a name
    enum Choice {
        Up,
        Down,
        Left,
        Right
    }

    Choice choice = Choice.Up;

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
