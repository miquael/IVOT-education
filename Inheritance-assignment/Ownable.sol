pragma solidity 0.7.5;
//SPDX-License-Identifier: UNLICENSED

//\\ -- OWNABLE -- //\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
contract Ownable {

    address internal owner; // internal is only accessible within this contract or inheriting contracts
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller must be contract owner");
        _; // run the function
    }

    // INIT //////////////////////////////////
    constructor() {
        // the contract deployer is always the owner
        owner = msg.sender;
    }

}