// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";

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

// ! Create burnable token
contract MyToken3 is ERC721, ERC721Burnable {
    //* The ERC721Burnable contract from OpenZeppelin does not have its own constructor;
    //* instead, it inherits the constructor from the ERC721 contract.
    //* When you create a contract that extends ERC721Burnable, you only need to 
    //* provide the constructor parameters required by the ERC721 contract.
    //* so we don't implement its constructor
    constructor() ERC721("MyToken", "MTK") {}

    // * Track the next token ID to mint
    uint256 private _nextTokenId;
    
    // * Public mint function
    function mint(address to) public {
        // Use the internal _mint function to mint the token
        uint256 tokenId = _nextTokenId++;
        _mint(to, tokenId);
    }
}

// ! Create burnable and pusable token
contract MyToken4 is ERC721Burnable, Pausable, Ownable {
    uint256 private _nextTokenId;

    constructor(address initialOwner)
        ERC721("MyToken", "MTK")
        Ownable(initialOwner)
    {}

    // Mint function with pausable modifier
    //! We should add whenNotPaused modifer
    function safeMint(address to) public onlyOwner whenNotPaused {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
    }

    // Pause the contract (owner only)
    function pause() public onlyOwner {
        _pause();
    }

    // Unpause the contract (owner only)
    function unpause() public onlyOwner {
        _unpause();
    }

    // Override burn to ensure it can't be called when paused
    //! We should add whenNotPaused modifer
    //? Note all functions can be only called from the owner, but burn function can be called from any where (just in this case but we can make it onlyOwner)
    function burn(uint256 tokenId) public override whenNotPaused {
        super.burn(tokenId);
    }
}