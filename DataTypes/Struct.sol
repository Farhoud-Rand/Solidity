// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";

// =================================================
// Struct data type
// =================================================
contract X {
    // in the following enum we will try to refect orders that might happen on off chain (shipped --> third party)
    //enum OrderStatus { Created, Paid, Shipped, Completed }
    // For simplicity we will make the OrderStatus be like:
    enum OrderStatus { Created, Paid }
    
    // group variables under a single name
    // can be stored in the different data locations
    // can go within other structs/arrays/mappings
    
    // We will facilitate the payment on chain
    struct Order {
        address buyer;
        address seller;
        uint256 amount;
        OrderStatus status; // Initially the status will be created and when the payment happened the status will be paid 
    }

    Order[] public orders;        
    // To make it able for user to modification on a specific order without iterate on all orders array (expensive), we will make the user key in a specific position in the array
    // To do that we need to create an event to till user that an order has been sccussefuly created and here is the key for it (index) so that they can modifiy it directly in the future
    // Event is the same as signal
    // indexed keyword: to make the user from outside the contract filter on a particular variable
    // something like this query: OrderCreated.where(key:key)  
    // But note that it will add gas cost so we should be sure that there is a need for it 
    event OrderCreated(uint256 indexed key, uint256 amount);

    // Function to create a new order and add it in orders list
    function createOrder ( address buyer, address seller, uint amount) external {
        // We can pass paramenter by order or as object
        // Order memory order = Order(buyer, seller, amount, OrderStatus.Created);
        Order memory order = Order({buyer:buyer, seller:seller,amount:amount,status:OrderStatus.Created });
        orders.push(order);
        // Send the event 
        emit OrderCreated(orders.length - 1, amount);
    }

    // Function to pay for a specific order by using its key
    // It should be a payable method (which will increase the contact balance) and there is some restrictions:
    // msg.val = amount
    // mgs.sender = buyer
    // order status should be created (make sure to pay only one time)
    function payment(uint256 key) external payable{
        Order storage order = orders[key]; // Use `storage` instead of `memory` to modify the array directly
        require(order.buyer == msg.sender, "Only the buyer can pay");
        require(order.amount == msg.value, "Incorrect payment amount");
        require(order.status == OrderStatus.Created, "Order has already been paid or is invalid");
        // Change the order status
        order.status = OrderStatus.Paid; 
        // Or if we make the order memory located variable we can change the order directly form orders list like:
        // orders[key].status = OrderStatus.Paid;
        // But note make a copy of it will be more expensive
    }

    // In Test we need to destarcture the order, another way is by doing this function
    function getOrder(uint256 key) external view returns(Order memory) {
        return orders[key];
    } 
}

// If this struct were defined outside of a contract, it can be shared across multiple contracts like so:
struct Account {
    uint balance;
    bool isActive;
}

contract A {
    Account owner;
    Account recipient;
}

contract B {
    mapping (address => Account) accounts;
}