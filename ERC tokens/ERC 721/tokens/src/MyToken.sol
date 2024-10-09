// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// ! Create basic token
contract MyToken is ERC721 {
    // * Implement the parent constructor 
    constructor() ERC721("MyToken", "MTK") {}
}