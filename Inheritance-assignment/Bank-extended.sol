pragma solidity 0.7.5;
//SPDX-License-Identifier: UNLICENSED

// import "@nomiclabs/builder/console.sol";
import "./Destroyable.sol";

//\\ -- BANK -- //\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
contract Bank is Ownable, Destroyable {

    address owner;
    mapping (address => uint) balance;
    
    event depositDone(uint amount, address indexed depositedTo);
    event transferDone(uint amount, address indexed sentFrom, address indexed sentTo);
    
    /*modifier onlyOwner() {
        require(msg.sender == owner);
        _; // run the function
    }*/

    modifier enoughBalance() {
        // check if balance of sender is sufficient
        // require(balance[msg.sender] >= amount,"Balance not sufficient");
        _; // run the function
    }

    modifier senderNotRec() {
        // check for redundancy
        // require(msg.sender != toRecipient, "Don't send money to yourself");
        _; // run the function
    }
        
    // INIT //////////////////////////////////
    constructor() {
        owner = msg.sender;
    }
    
    // DEPOSIT - payable //////////////////////////////////
    function deposit() public payable returns(uint) {
        balance[msg.sender] += msg.value;
        emit depositDone(msg.value, msg.sender);
        return balance[msg.sender];
    }
    
    // GET BALANCE - read only //////////////////////////////////
    function getBalance() public view returns(uint) {
        return balance[msg.sender];
    }
    
    // WITHDRAW //////////////////////////////////
    function withdraw(uint amount) public returns (uint)  {
        // msg.sender is an address, and address has a method to trasfer 
        msg.sender.transfer(amount);
        // adjust balance
        balance[msg.sender] -= amount;
        return balance[msg.sender];
    }
    
    // TRANSFER TO //////////////////////////////////
    function tranferTo(address recipient, uint amount) public {
        // check if balance of sender is sufficient
        require(balance[msg.sender] >= amount,"Balance not sufficient");
        // check for redundancy
        require(msg.sender != recipient, "Don't send money to yourself");

        uint previousSenderBalance = balance[msg.sender];
        _transfer(amount, msg.sender, recipient);

        assert(balance[msg.sender]==previousSenderBalance - amount);
        emit transferDone(amount, msg.sender, recipient);
    }

    // _TRANSFER - private //////////////////////////////////
    function _transfer(uint amount, address from, address to) private {
        balance[from] -= amount;
        balance[to] += amount;
    }

}