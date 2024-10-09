// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// ! Create basic token
contract MyToken is ERC721 {
    // * Implement the parent constructor 
    constructor() ERC721("MyToken", "MTK") {}
}

// ! Create mintable token 
contract MyToken1 is ERC721, Ownable {
    // * Implement the 2 parent constructors
    constructor(address initialOwner)
        ERC721("MyToken", "MTK")
        Ownable(initialOwner)
    {}

    // * Mint function to add new tokens and assign ownership of those tokens to the address that create the token (deployed the contract)
    function mint(address to, uint256 tokenId) public onlyOwner {
        // todo: Note we use _mint for minting without safe checks, to make the contract able to handle tokens without check them
        _mint(to, tokenId);
    }
}