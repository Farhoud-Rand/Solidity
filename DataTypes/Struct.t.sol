// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Counter.sol";

contract CounterTest is Test {
    X public x;

    function setUp() public {
        x = new X();
    }

    function testExample() public {
        x.createOrder(address(0), address(1), 1 ether);
        // To make the address for test as a specific address we should use hoax(msgSender);
        // We need to make the address to be the same as sender address in order to be able to modified it or pay for it
        // hoax is a forage utility to make it easier to run tests
        hoax(address(0)); // now we are acting as address 0
        x.payment{value: 1 ether}(0);
        assertEq(address(x).balance, 1 ether);
        // Note: OrderStatus (enum) and Order (struct) should be call using contract name not the object !
        (,,,X.OrderStatus status) = x.orders(0);
        // snice asserEq cannot compare enum we need to convert it to uint
        assertEq(uint8(status),uint8(X.OrderStatus.Paid));
        // Without destarcture the order object, by using getOrder function
        X.Order memory order = x.getOrder(0);
        assertEq(uint8(order.status),uint8(X.OrderStatus.Paid));
    }
}