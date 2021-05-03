// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    //add minter variable
    address public minter;

    //add minter changed event
    event MinterChange(address indexed from, address to);

    constructor() public payable ERC20("m_coins", "MCX") {
        //asign initial minter
        minter = msg.sender;
    }

    //Add pass minter role function
    function passMinterRole(address cryptoBank) public returns (bool) {
        require(msg.sender == minter, "Only minter can change the role");
        minter = cryptoBank;

        emit MinterChange(msg.sender, cryptoBank);
        return true;
    }

    function mint(address account, uint256 amount) public {
        //check if msg.sender have minter role
        require(msg.sender == minter, "Not the minter");
        _mint(account, amount);
    }
}
