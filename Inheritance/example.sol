// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";
import {ownable} from "./Ownable.sol";

contract Example {
    uint importantVar;

    function privilegedMethod(uint x) external onlyOwner {
        importantVar = x;
    }

    event TransferOwnership(address oldOwner, address newOwner);

    // think of virtual and override as compliments,
    // we can override this method because it is declared as virtual in the base contract
    function transferOwner(address newOwner) public override onlyOwner {
        // Get the old ower before change it, to use it in event
        address oldOwner = owner;
        // call the function on the base or parent contract, Ownable
        super.transferOwner(newOwner);
        emit TransferOwnership(oldOwner, newOwner);
    }
}