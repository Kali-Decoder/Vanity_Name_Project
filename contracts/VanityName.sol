// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract Vanity {
    address public admin;
    uint public numberOfVanity;
    constructor(){
        admin= msg.sender;
    }
    struct VanityName{
        uint id;
        string name;
        address owner;
        uint expire;
        bool valid;
    }
    mapping(string => address) public stringToOwner;
    mapping(uint=>VanityName)  public vanities;

    function registerYourName(string memory _name) public payable returns(bool){
        numberOfVanity++;
        require(stringToOwner[_name]==address(0),"Already an Owner of this Name");
        uint price = getPrice(_name);
        require(msg.value==price,"You dont have enough money to purchase this domain");
        vanities[numberOfVanity]= VanityName(numberOfVanity,_name,msg.sender,block.timestamp+ 3600,true);// 1 hour validity for this time
        stringToOwner[_name]=msg.sender;
        payable(admin).transfer(price);
        return true;
    }

    function getPrice(string memory _name) public pure returns(uint){
        return _calcAmount(_name);
    }

    // if you want to extend  30 minutes  expire time you have to pay 1000 wei again 

    function extendTime(uint id, uint _howMuchTimes) payable public _Exist(id) _isOwner(id) returns(bool) {
        uint price = _howMuchTimes * 1000 ;
        uint increaseTime= _howMuchTimes*30*60;
        require(msg.value==price,"Not sufficient balance");
        VanityName storage vanityname= vanities[id];
        uint remaingTime= (block.timestamp-vanityname.expire);
        if(remaingTime<=0){
            vanityname.valid=false;
            stringToOwner[vanityname.name]=address(0);
            return true;
        }
        vanityname.expire=  remaingTime + increaseTime;
        return true;
    }   

    function vanityIsValid(uint id) view public returns(bool){
        VanityName storage vanity= vanities[id];
        return vanity.valid;
    }
    

    function _calcAmount(string memory _name) pure private returns(uint){
        bytes memory name =  bytes(_name);
        uint price;
        uint len = name.length;
        if(len>0 && len<=10){
            price= 10000 wei;
        }
        else if(len>10 && len<=20){
            price = 20000 wei ;

        }else if(len>20){
            price = 50000 wei;
        }
        return price;
    }
    modifier _Exist(uint id){
        require(id>0 && id<= numberOfVanity,"Vanity is not exist ");
        _;
    }
    modifier _isOwner(uint id ){
        VanityName storage vanityname= vanities[id];
        require(vanityname.owner==msg.sender,"You are not the owner of this name");
        _;
    }
}