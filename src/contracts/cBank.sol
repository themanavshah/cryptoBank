// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "./Token.sol";

contract cBank {
    //assign Token contract to variable
    Token private token;

    //add mappings
    mapping(address => uint256) public etherBalanceOf;
    mapping(address => uint256) public depositStart;
    mapping(address => bool) public isDeposited;

    //add events
    event Deposit(address indexed user, uint256 etherAmount, uint256 timeStart);
    event WithDraw(
        address indexed user,
        uint256 etherAmount,
        uint256 timeStamp,
        uint256 intrest
    );

    //pass as constructor argument deployed Token contract
    constructor(Token _token) public {
        //assign token deployed contract to variable
        token = _token;
    }

    function deposit() public payable {
        //check if msg.sender didn't already deposited funds
        require(isDeposited[msg.sender] == false, "Depositer ready active");
        //check if msg.value is >= than 0.01 ETH
        require(
            msg.value >= 1e16,
            "deposited value must be greater that 0.01 ETH"
        );
        etherBalanceOf[msg.sender] = etherBalanceOf[msg.sender] + msg.value;
        depositStart[msg.sender] = depositStart[msg.sender] + block.timestamp;

        //set msg.sender deposit status to true
        isDeposited[msg.sender] = true;
        //emit Deposit event
        emit Deposit(msg.sender, msg.value, block.timestamp);
    }

    function withdraw() public {
        //check if msg.sender deposit status is true
        require(isDeposited[msg.sender] == true, "No previous deposits");
        uint256 userBalance = etherBalanceOf[msg.sender];

        //assign msg.sender ether deposit balance to variable for event
        //check user's hodl time
        uint256 depositeTime = block.timestamp - depositStart[msg.sender];

        //calc interest per second
        //calc accrued interest
        //send interest in tokens to user
        //31668017 - intrest(10% APY ) per second for min, deposit amount (0.01), cuz:
        //1e15(10% of 0.01 ETH ) / 31577600 (sec in a year)
        uint256 intrestPerSecond =
            31668017 * (etherBalanceOf[msg.sender] / 1e16);
        uint256 intrest = intrestPerSecond * depositeTime;

        //send eth to user
        msg.sender.transfer(userBalance);
        token.mint(msg.sender, intrest);

        //reset depositer data
        depositStart[msg.sender] = 0;
        etherBalanceOf[msg.sender] = 0;
        isDeposited[msg.sender] = false;

        //emit event
        emit WithDraw(msg.sender, userBalance, depositeTime, intrest);
    }

    function borrow() public payable {
        //check if collateral is >= than 0.01 ETH
        //check if user doesn't have active loan
        //add msg.value to ether collateral
        //calc tokens amount to mint, 50% of msg.value
        //mint&send tokens to user
        //activate borrower's loan status
        //emit event
    }

    function payOff() public {
        //check if loan is active
        //transfer tokens from user back to the contract
        //calc fee
        //send user's collateral minus fee
        //reset borrower's data
        //emit event
    }
}
