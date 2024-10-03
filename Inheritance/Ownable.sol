// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";

contract Ownable {
  address owner = msg.sender;

  // virtual allows this method to be overriden
  function transferOwner(address newOwner) public virtual onlyOwner {
    owner = newOwner;
  }

  error NotTheOwner();
  modifier onlyOwner {
    if(msg.sender != owner) {
      revert NotTheOwner();
    }
    _;
  }
}