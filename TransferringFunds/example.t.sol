// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Contract.sol";

contract ContractTest is Test {
    Contract public myContract;
    address msgSender = address(3);
    A public a;
    B public b;

    function setUp() public {
        vm.prank(msgSender);
        b = new B();
        a = new A {value:1 ether} (address(b));
        myContract = new Contract(a,b);
    }

    function testSendEther() public {
        address contractAddr = address(myContract);
        contractAddr.call{ value: 2 ether }("");
        assertEq(contractAddr.balance, 2 ether);
    }

    function testTip() public {
        myContract.tip{ value: 1 ether }();
        assertEq(msgSender.balance, 1 ether);
    }

    function testPayA() public {
        myContract.payA{ value: 1 ether }("");
        assertEq(a.balance, 1 ether);
    }
}
