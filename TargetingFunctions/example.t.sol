// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {A,B} from "../src/Counter.sol";

contract CounterTest is Test {
    A public a;
    B public b;

    function setUp() public {
        b = new B();
        a = new A (address(b),8,8);
    }

    function testExample() public {
        a.doOperations();
    }
}
