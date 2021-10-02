pragma solidity 0.7.5;

//SPDX-License-Identifier: UNLICENSED

import "./Ownable.sol";

//\\ -- DESTROYABLE -- //\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
contract Destroyable is Ownable {

    // DESTROY - //////////////////////////////////
    function destroy() public onlyOwner {
        // - requires a payable address
        address payable receiver = msg.sender;
        // - automatically transfers remaining contract balance to an address
        selfdestruct(receiver);
        // selfdestruct(owner); // < this works too?
    }
}

