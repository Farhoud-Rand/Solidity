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
        owner = vm.addr(1);     // Use a different address, or you could also just set it to a specific address
        user = address(0x123);  // Simulate another user address

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
        //! Note we should change the test address to be the owner address
        //* vm.prank(address) is used to simulate the action of a specific address calling a function. 
        //* This allows you to change the context of a function call to appear as if it were made by 
        //* a different account (or address) than the one currently executing the test.
        vm.prank(owner); //! add this 
        token.safeMint(owner);
        uint256 tokenId = 0; // Since this is the first token, ID should be 0

        // Check the owner of token ID 0
        assertEq(token.ownerOf(tokenId), owner);
        
        //! Note
        //! To allow a second minting operation by user, you will need to adjust your logic.
        //! Since only the owner can mint new tokens, you could perform the second minting operation
        //! by calling it through the owner (the test contract).

        // Mint a second token to the user, but do it as the owner
        vm.prank(owner);            // Set the context back to the owner
        token.safeMint(user);       // Now mint to the user
        uint256 secondTokenId = 1;  // The second token should have ID 1

        // Check the owner of token ID 1
        assertEq(token.ownerOf(secondTokenId), user);
    }

    // * Test minting is restricted to the contract owner
    function testMintByNonOwner() public {
        // Expect a revert when a non-owner tries to mint
        vm.prank(user);                                       // Simulate calling from the user address
        vm.expectRevert("Ownable: caller is not the owner"); // Expect revert
        token.safeMint(user);
    }
}

// ! Test burnable token
contract MyToken3Test is Test {
    MyToken3 private token;

    address private owner; // Address for the contract owner

    function setUp() public {
        owner = address(this); // Set the test contract as the owner

        // Deploy the MyToken3 contract
        token = new MyToken3();
    }

    // * Test burning function
    function testBurn() public {
        uint256 tokenId = 0; // ID of the token to burn

        // Mint a token directly using the _mint function
        token.mint(owner);

        // Ensure the token exists before burning
        assertEq(token.ownerOf(tokenId), owner);

        // Burn the token
        token.burn(tokenId);

        // Check that the token no longer exists
        // Expect the call to revert since the token has been burned
       vm.expectRevert("ERC721: owner query for nonexistent token");
       token.ownerOf(tokenId); // This should revert since the token is burned
    }
}