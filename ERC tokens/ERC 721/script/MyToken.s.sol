// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/MyToken.sol";

contract DeployMyToken is Script {
    function run() external {
        // Start broadcasting the transaction
        vm.startBroadcast();

        // Deploy the MyToken contract
        MyToken token = new MyToken();

        // Stop broadcasting
        vm.stopBroadcast();

        // Optionally, you can log the address of the deployed contract
        console.log("MyToken deployed at:", address(token));
    }
}
