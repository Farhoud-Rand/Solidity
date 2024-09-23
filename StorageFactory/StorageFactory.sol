// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;
// Import all the file
// import "./SimpleStorage.sol";

// Named import
// import {SimpleStorage, SimpleStorage2} from "./SimpleStorage.sol";
import {SimpleStorage} from "./SimpleStorage.sol";

// This contract will be as a manger for other contracts 
contract StorageFactory {
    // Instead of saving all objects, we can save the addresses for them like address[] public addressesOfListOfSimpleStorageContracts 
    // And if we want to get the object form its address we can cast it like --> SimpleStorage(address)
    SimpleStorage[] public listOfSimpleStorageContracts;

    // Function to create a simple storage contract and save them in the state variable (array)
    function createSimpleStorageContract() public {
        SimpleStorage simpleStorageContractVariable = new SimpleStorage();
        listOfSimpleStorageContracts.push(simpleStorageContractVariable);
    }

    // Function to store a favorite number for each one by its index
    // This function will call the store function from SimpleStorage contract
    function sfStore(
        uint256 _simpleStorageIndex,
        uint256 _simpleStorageNumber
    ) public {
        // In order to interacte with a contract we always need:
        // * Address
        // * ABI --> (technially a lie, you just need the function selector), Application Binary Interface, it will tell our code exactly how it can interact with another contract 
        
        // With casting 
        // SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).store(_simpleStorageNumber);
        // First we need to get the simple storage object by its index then we can call store function 
        listOfSimpleStorageContracts[_simpleStorageIndex].store(
            _simpleStorageNumber
        );
    }

    // Function to get the favoirte number for each one by its index
    // It also will call a function (retrieve) from SimpleStorage contract
    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        // With casting 
        // return SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).retrieve();
        // First we need to get the simple storage object by its index then we can call retrieve function 
        return listOfSimpleStorageContracts[_simpleStorageIndex].retrieve();
    }
}