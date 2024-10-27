// SPDX-License-Identifier: MIT

import {AggregatorV3Interface} from "@chainlink/contracts@1.2.0/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

pragma solidity ^0.8.19;
// 1. Allow users to send funds into the contract: users should be able to deposit funds into the 'FundMe' contract
// 2. Enable withdrawal of funds by the contract owner: the account that owns `FundMe` should have the ability to withdraw all deposited funds
// 3. Set a minimum funding value in USD: there should be a minimum amount that can be deposited into the contract

contract fundMe {
    // Minimum fund amount
    // 1e18 = 1 ETH = 1 * 10 ** 18
    uint256 min = 5e18; // 5 dolor and since getConversionRate function return a number with 18 dicmal places we need to add (10 ** 18)
    // Note: 1 Ether = 1e9 Gwei = 1e18 Wei
    // Funders addresses
    address[] public funders;
    // Funders addresses with the amount they fund
    mapping(address funder => uint256 amountFunded) public adddressToAmountFunded;

    // fund function allows users to deposit funds into the contract
    function fund() public payable {
        // This function will require a _minimum amount of ETH_ to ensure proper transaction handling
        // msg.value property -> it is part of the _global object_ `msg`. It represents the amount of Wei transferred in the current transaction
        //Note that Wei is the smallest unit of Ether (ETH)
        require(getConversionRate(msg.value) >= min,  "Didn't send enough ETH"); //if the condition is false, revert with the error message
        funders.push(msg.sender);
        adddressToAmountFunded[msg.sender] = adddressToAmountFunded[msg.sender] + msg.value;
    }

    // Get the price of ethereum in terms of USD using chainlink data feed
    function getPrice() public view returns(uint256) {
        // To use chainlink data feed we need:
        // 1) address => docs.chain.link.data-feeds/addresses -> ETH/USD: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // 2) ABI => interface (AggregatorV3Interface) -> cast the address to be the same as interface so we can use the contract functions like this
        //  AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).functionName
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price,,,) = priceFeed.latestRoundData();
        // The price will be something like 2000.00000000 abd 1 ether = 1*10^18 so there is 10 diffrent digits
        // the latestRoundData function return price in int because it could be negative 
        // and the msg.value will be uint256 so we need to cast it
        return uint256(price * 1e10);
    }

    // Convert the value (value in transaction) to its converted value based off the price 
    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
        // Example 1ETH = ? in USD
        // if it = 2000_000000000000000000
        uint256 ethPrice = getPrice();
        // We should divide by 1*10^18 because both numbers have 18 decimal places
        // (2000_000000000000000000 * (1ETH)1_000000000000000000) / 1e18
        // so we get $2000 (with 18 decimal places) = 1ETH 
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    // withdraw function grants the contract owner the ability to withdraw the funds that have been previously deposited
    function withdraw() public {}
}