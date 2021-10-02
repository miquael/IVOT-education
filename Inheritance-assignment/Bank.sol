pragma solidity 0.7.5;
//SPDX-License-Identifier: UNLICENSED

// local contract
import "./Destroyable.sol";

// external contract 
interface GovernmentInterface {
    function addTransaction(address _from, adress _to, uint amount) external payable;
}

//\\ -- BANK -- //\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
contract Bank is Ownable, Destroyable {

    // external contract
    GovernmentInterface governmentInstance = GovernmentInterface(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);

    mapping (address => uint) balance;
    
    event depositDone(uint amount, address indexed depositedTo);
    event transferDone(uint amount, address indexed sentFrom, address indexed sentTo);

    modifier enoughBalance(uint amount) {
        // check if balance of sender is sufficient
        require(balance[msg.sender] >= amount,"Balance not sufficient");
        _; // run the function
    }

    modifier senderNotRec(address recipient) {
        // check for redundancy
        require(msg.sender != recipient, "Don't send money to yourself");
        _; // run the function
    }
    
    // DEPOSIT - payable //////////////////////////////////
    function deposit() public payable returns(uint) {
        balance[msg.sender] += msg.value;
        emit depositDone(msg.value, msg.sender);
        return balance[msg.sender];
    }
    
    // WITHDRAW //////////////////////////////////
    function withdraw(uint amount) public enoughBalance(amount) returns (uint)  {
        // msg.sender is an address, and address has a method to trasfer 
        msg.sender.transfer(amount);
        // adjust balance
        balance[msg.sender] -= amount;
        return balance[msg.sender];
    }

    // GET BALANCE - read only //////////////////////////////////
    function getBalance() public view returns(uint) {
        return balance[msg.sender];
    }
    
    // TRANSFER TO //////////////////////////////////
    function tranferTo(address recipient, uint amount) public enoughBalance(amount) senderNotRec(recipient) {
        // check
        uint previousSenderBalance = balance[msg.sender];
        assert(balance[msg.sender] == previousSenderBalance - amount);

        // tranfer 
        _transfer(amount, msg.sender, recipient);

        // call to external contract *** report transfer
        govermentInstance.addTransaction(msg.sender, recipient, amount);

        emit transferDone(amount, msg.sender, recipient);
    }

    // _TRANSFER - private //////////////////////////////////
    function _transfer(uint amount, address from, address to) private {
        balance[from] -= amount;
        balance[to] += amount;
    }

}