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

// ! Test mintable token 
contract MyToken1Test is Test {
    MyToken1 private token;

    address private owner;
    address private user;

    function setUp() public {
        owner = address(this); // Set the test contract as the owner
        user = address(0x123); // Simulate another user address

        // Deploy the MyToken1 contract with the test contract as the initial owner
        token = new MyToken1(owner);
    }

    function testMintByOwner() public {
        // Mint a token with ID 0 to the owner
        token.mint(owner, 0);

        // Check the owner of token ID 0
        assertEq(token.ownerOf(0), owner);
    }

    function testMintByNonOwner() public {
        // Expect a revert when a non-owner tries to mint
        vm.prank(user); // Simulate user calling the contract
        vm.expectRevert("Ownable: caller is not the owner"); // Expect revert
        token.mint(user, 0);
    }
}