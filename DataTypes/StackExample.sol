// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract StackClub {
    // Define a dynamic array to be the stack
    address [] members;

    // Add the deployer address as the first member of the stack
    constructor() {
         members.push(msg.sender);
    } 

    // Function which will add new address to member stack
    function addMember(address newAddress) external onlyExistingMember{
        members.push(newAddress);
    }

    // Function which will check if this address is in the stack 
    function isMember(address searchAddress) external view returns(bool){
        for(uint i =0; i < members.length; i++){
            if (members[i] == searchAddress)
                return true;
        }
        return false;
    }

    // Function which will remove the last member added to the stack
    function removeLastMember() external onlyExistingMember{
        members.pop();
    }

    // For Function Security
    // The removeLastMember function can only be called by an existing member
    // The addMember can only be called by an existing member
    modifier onlyExistingMember {
        bool checkMember = false;
        
        // Check if the sender is in the members array
        for (uint i = 0; i < members.length; i++) {
            if (msg.sender == members[i]) {
                checkMember = true;
                break;
            }
        }

        // If the sender is not a member, revert with an error message
        if (!checkMember) {
            revert("You are not a member");
        }

        // Proceed with the rest of the function if the sender is a member
        _;
    }
}