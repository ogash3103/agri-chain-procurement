// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AgriChainProcurement {

    // 🔹 STEP 3.1 — STATE VARIABLES
    uint public orderCount;
    address public owner;

    // 🔹 STEP 3.2 — CONSTRUCTOR
    constructor() {
        owner = msg.sender;
    }

    // 🔹 STEP 4 — ORDER STRUCTURE
    struct Order {
        uint id;
        address farmer;
        address buyer;
        uint price;
        bool delivered;
        bool paid;
    }

    // 🔹 STEP 4.1 — STORAGE
    mapping(uint => Order) public orders;

    // 🔹 STEP 5 — CREATE ORDER
    function createOrder(address _farmer, uint _price) public {
        orderCount++;

        orders[orderCount] = Order(
            orderCount,
            _farmer,
            msg.sender,
            _price,
            false,
            false
        );
    }

    // 🔹 STEP 6 — CONFIRM DELIVERY
    function confirmDelivery(uint _orderId) public {
        Order storage order = orders[_orderId];

        require(msg.sender == order.farmer, "Only farmer can confirm");
        require(!order.delivered, "Already delivered");

        order.delivered = true;
    }

    // 🔹 STEP 7 — RELEASE PAYMENT
   function releasePayment(uint _orderId) public payable {
    Order storage order = orders[_orderId];

    require(order.delivered, "Not delivered yet");
    require(!order.paid, "Already paid");
    require(msg.value == order.price, "Incorrect amount");

    order.paid = true;

    (bool success, ) = payable(order.farmer).call{value: msg.value}("");
    require(success, "Payment failed");
}


}
