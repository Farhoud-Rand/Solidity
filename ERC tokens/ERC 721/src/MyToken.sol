// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
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

// ! Create mintable token with auto increment ID 
contract MyToken2 is ERC721, Ownable  {
    uint256 private _nextTokenId;

    // * Implement the 2 parent constructors
    constructor(address initialOwner)
        ERC721("MyToken", "MTK")
        Ownable(initialOwner)
    {}

    // * Mint function to add new tokens and assign ownership of those tokens to the address that create the token (deployed the contract)
    function safeMint(address to) public onlyOwner {
        // todo Note we use _safeMint for minting with safe checks, which means that the function checks if the to address can receive ERC721 tokens, ensuring tokens aren't mistakenly sent to contracts that don't support them
        // todo  It ensures tokens aren’t sent to contracts that cannot handle them, preventing tokens from being locked in contracts without the ability to recover them
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
    }
}