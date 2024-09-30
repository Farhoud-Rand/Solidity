// Escrow is the first useful solidity smaert contract 
// Escrow is an agreement between 2 parties to transfer some value or funds in echange for a good or service, arbitrated by a 3rd party or condition
// Funds can be held in escrow and a third party can be chosen to "arbitrate" or approve the transfer when the service or good is provided
// So 2 parties will send ether from one to another while the third party will agree when is the time to move fund from first party to the second party
// We could think about the 3rd party as a series of stack holders who all have a smart contract that will approve the transaction to go through 
// So in the Escrow we have:
// Depositor(deployer) --> the party of the Escrow, makes the inital deposit that will eventually go to the beneficiary
// Beneficiray --> the receiver of the funds. They will provide some service or good to the depositor before the funds are transferred by the arbiter
// Arbiter --> The approver of the transaction. They alone can move the funds when the goods/services have been provided

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";

contract Escrow {
    // We need to create a 3 storage variables for the addresses of the depositor, beneficiary and arbiter 
    address public depositor;
    address public beneficiary;
    address public arbiter; 

    // We emit events when something important happens 
    // When we emit an event we give the server and user interfaces the ability to be able to key in a spceific pice of data
    // This event will be used to it to say that Escrow has been approved 
   event Approved(uint);

    // Set the value of these adddresses in the constructor 
    // Note that the contract will be deployed by the depositor (who will be pay for the service so the constructor will be payable) 
    constructor(address _arbiter, address _beneficiary) payable{
        arbiter = _arbiter;
        beneficiary = _beneficiary;
        depositor = msg.sender;
    }

    // Once the good or service is provided, the arbiter needs a way to approve the transfer of the deposit over to the beneficiary's account. 
    function approve() external{
        // Only arbiter should be able to call the approve method
        if (msg.sender == arbiter){
            (bool successs,) = beneficiary.call{value:address(this).balance}("");
            emit Approved(beneficiary.balance);
        // Revert the transaction
        } else 
            revert("You cannot call this function");
    }
}

