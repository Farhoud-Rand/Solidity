// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {A,B} from "../src/Counter.sol";

contract CounterTest is Test {
    A public a;
    B public b;

    function setUp() public {
        b = new B();
        // Note 1 ether will equal 1000000000000000000 (10^18) wei
        // We need to cast b to address
        a = new A {value:1 ether} (address(b));
    }

    function testExample() public {
        assertEq(address(a).balance, 1 ether);
        assertEq(address(b).balance, 0);
        a.payHalf();
        assertEq(address(a).balance, 0.5 ether);
        assertEq(address(b).balance, 0.5 ether);
    }
}
