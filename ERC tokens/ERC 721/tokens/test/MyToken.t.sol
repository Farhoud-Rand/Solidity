// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/MyToken.sol";

// ! Test basic token
contract MyTokenTest is Test {
    MyToken private token;

    function setUp() public {
        // Deploy the MyToken contract before each test
        token = new MyToken();
    }

    function testTokenName() public view {
        // Check that the token name is correct
        assertEq(token.name(), "MyToken");
    }

    function testTokenSymbol() public view {
        // Check that the token symbol is correct
        assertEq(token.symbol(), "MTK");
    }
}