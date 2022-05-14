// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract Vanity {
    address public admin;
    uint256 public numberOfVanity;

    constructor() {
        admin = msg.sender;
    }

    struct VanityName {
        uint256 id;
        string name;
        address owner;
        uint256 expire;
        bool valid;
    }
    mapping(string => address) public stringToOwner;
    mapping(uint256 => VanityName) public vanities;

    receive() external payable {}

    function registerYourName(string memory _name)
        public
        payable
        returns (bool)
    {
        numberOfVanity++;
        require(
            stringToOwner[_name] == address(0),
            "Already an Owner of this Name"
        );
        uint256 price = getPrice(_name);
        require(
            msg.value == price,
            "You dont have enough money to purchase this domain"
        );
        vanities[numberOfVanity] = VanityName(
            numberOfVanity,
            _name,
            msg.sender,
            block.timestamp + 3600,
            true
        ); // 1 hour validity for this time
        stringToOwner[_name] = msg.sender;
        return true;
    }

    function getPrice(string memory _name) public pure returns (uint256) {
        return _calcAmount(_name);
    }

    // if you want to extend  30 minutes  expire time you have to pay 1000 wei again

    function increaseValidity(uint256 id, uint256 _times)
        public
        payable
        _Exist(id)
        _isOwner(id)
        returns (bool)
    {   
        uint price = _times * (1 ether);
        require(price==msg.value,"Please give me more money");
        VanityName storage vanity = vanities[id];
        uint256 increaseTime = _times * (1800); 
        uint remainingTime= block.timestamp- vanity.expire;
        if(remainingTime<=0){
            remainingTime=0;
        }
        vanity.expire = remainingTime + increaseTime;

        return true;
    }

    function vanityIsValid(uint256 id) public view returns (bool) {
        VanityName storage vanity = vanities[id];
        return vanity.valid;
    }

    function _calcAmount(string memory _name) private pure returns (uint256) {
        bytes memory name = bytes(_name);
        uint256 price;
        uint256 len = name.length;
        if (len > 0 && len <= 10) {
            price = 1 ether;
        } else if (len > 10 && len <= 20) {
            price = 2 ether;
        } else if (len > 20) {
            price = 5 ether;
        }
        return price;
    }

    modifier _Exist(uint256 id) {
        require(id > 0 && id <= numberOfVanity, "Vanity is not exist ");
        _;
    }
    modifier _isOwner(uint256 id) {
        VanityName storage vanityname = vanities[id];
        require(
            vanityname.owner == msg.sender,
            "You are not the owner of this name"
        );
        _;
    }
    modifier isAdmin() {
        require(admin == msg.sender, "You are not contract Holder");
        _;
    }

    function getBal() public view returns (uint256) {
        return address(this).balance;
    }
}
