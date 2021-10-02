pragma solidity 0.7.5;
contract EventAssignment {

    event transferMade(address indexed recipient, uint indexed amount, address indexed sender);

    function transfer(address recipient, uint amount) public {
         require(balance[msg.sender] >= amount "Balance not sufficient");
         require(msg.sender != recipient, "Don't transfer money to yourself");

         uint previousSenderBalance = balance[msg.sender];

         _transfer(msg.sender, recipient, amount);

         assert(balance[msg.sender] == previousSenderBalance - amount);

         emit transferMade(recipient, amount, msg.sender);
    }
}