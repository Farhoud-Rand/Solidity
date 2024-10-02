// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";

contract X {
    // These state variables by default saved in storage (variables at contract level)
    // So we don't need to specify the location explicitly like (uint[] storage allNumbers;) 
    // These arrays have their size determined at compile-time. They cannot grow or shrink in size.
    // If you store less elements in the array than the fixed size, the rest of the elements will be the default value for the data type 
    uint[3] favoriteNumbers; // Fixed size array (3)
    uint[] allNumbers;       // Dynamic size array (unlimited)

    // The size is dynamically provided by the variable size for initialize fixed size aaray
    uint size = 5;
    
    constructor() {
        // After initialization, memory arrays cannot be resized
        address[] memory addresses = new address[](x);
        // push and pop are allowed only on dyamic arrays
        // Note we will not often pushing elements into array
        // Because iteration is a gas consuming operation
        allNumbers.push(1);
        allNumbers.push(2);
        allNumbers.push(3);

        // Push function is not allowed on fixed size arrays (only by using key)
        favoriteNumbers[0] = 1;

        // compiled error --> try to add on index that is out of bounds array access
        // favoriteNumbers[5] = 4;

        // Run time error --> put the index in a varaible 
        // uint x = 4;
        // favoriteNumbers[x] = 5;
        
        // Storage location --> as referance type (means if we change the value in the function we will change the original value), it is for persistence
        modifyArray(favoriteNumbers);
        console.log(favoriteNumbers[0]); // 22

        // calldata location --> Refers to the data passed into the function (referring to message call arguments), read-only, temporary storage
        // Note the following is rarely used syntax in the same contract (with external, private modifier)
        // this. --> it will do a message call to our contract, and this operation is not gas efficient so don't do it
        // Note that this keyword cannot be used inside constructor !!
        this.readArr(favoriteNumbers);
        console.log(favoriteNumbers[1]); // 0

        // Memory location --> Temporary location (it will only last as long as the transaction), creates a copy of the reference type passed in
        this.readArray(favoriteNumbers);
        console.log(favoriteNumbers[2]); // 0
    }

    // Reflect the changes on the original variable  
    function modifyArray(uint[3] storage nums) private {
        nums[0] = 22;
    }

    // Only used with external functions 
    // Rarely used in the same contract (external modifier)
    // When we call function directly within the contact, we will note call it via message calls(we use it to call another function from another contact)
    // So we use calldata with message calls
    function readArr(uint[3] calldata arr) external view {
        // cannot write to the array
        console.log(arr[0]); // 22
    }

    // Only used with external functions 
    function readArray(uint[3] memory arr) private view {
        arr[0] = 5;
        console.log(arr[0]); // 5
    }

    // It is not possible to create a truly dynamic array in memory without specifying a length at the time of creation. Memory arrays must always have a fixed length when they are created
    function filter(uint[] calldata numbers) 
        external 
        pure 
        returns(uint[] memory) 
    {
        // So we need to specify the length first then create the array
        // find the number of elements over 5
		uint elements;
		for(uint i = 0; i < numbers.length; i++) {
			if(numbers[i] > 5) {
                elements++;
            }
		}

        // create a new array with this size
		uint[] memory filtered = new uint[](elements);
        // keep an index for the positions we have filled
		uint filledIndex = 0;
		for(uint i = 0; i < numbers.length; i++) {
			if(numbers[i] > 5) {
				filtered[filledIndex] = numbers[i];
				filledIndex++;
			}
		}
		return filtered;
	}
}