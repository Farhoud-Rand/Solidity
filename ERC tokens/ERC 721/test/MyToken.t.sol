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

// ! Test mintable token with auto increment ID 
contract MyToken2Test is Test {
    MyToken2 private token;

    address private owner; // Address for the contract owner
    address private user;  // Address for another user

    function setUp() public {
        owner = address(this); // Set the test contract as the owner
        user = address(0x123); // Simulate another user address

        // Deploy the MyToken2 contract with the test contract as the initial owner
        token = new MyToken2(owner);
    }

    // * Test token name and symbol
    function testTokenNameAndSymbol() public view {
        // Check that the token name is correct
        assertEq(token.name(), "MyToken");
        // Check that the token symbol is correct
        assertEq(token.symbol(), "MTK");
    }

    // * Test minting function by the owner
    function testMintByOwner() public {
        // Mint a token to the owner
        token.mint(owner);
        uint256 tokenId = 0; // Since this is the first token, ID should be 0

        // Check the owner of token ID 0
        assertEq(token.ownerOf(tokenId), owner);

        // Mint a second token to the user
        token.mint(user);
        uint256 secondTokenId = 1; // The second token should have ID 1

        // Check the owner of token ID 1
        assertEq(token.ownerOf(secondTokenId), user);
    }

    // * Test minting is restricted to the contract owner
    function testMintByNonOwner() public {
        // Expect a revert when a non-owner tries to mint
        vm.prank(user); // Simulate calling from the user address
        vm.expectRevert("Ownable: caller is not the owner"); // Expect revert
        token.mint(user);
    }
}