// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {SimpleStorage} from "./SimpleStorage.sol";

// This class will inherit the SimpleStorage contract and override the store function
contract AddFiveStorage is SimpleStorage {
    // In order to override a function we should add override specifier here and virtual specifier in the parent contract
    function store(uint256 _favoriteNumber) public override {
        myFavoriteNumber = _favoriteNumber + 5;
    }
}