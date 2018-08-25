pragma solidity ^0.4.17;

contract Coinflip {
    address owner;
    mapping(address => bool) lastFlip;  //stores bool won/lose flag of a last game for each player 
    
    function Coinflip() public {
        owner=msg.sender;
    }

    function getBalance() constant public returns (uint) {
        return this.balance;
    }

    function flip() payable public {
        uint time = block.timestamp;
        uint bet = msg.value;
        
        if (time % 2 == 0) {
            msg.sender.transfer(bet*2);
            lastFlip[msg.sender] = true;
        } else {
            lastFlip[msg.sender] = false;
        }
    }

    //constant means it doesn't change any variables
    //I need player address because there is no msg.sender available here - because there is no transaction on blockchain
    function getLastFlip(address _player) constant public returns (bool){
        return lastFlip[_player];
    }

    //contract needs some eth to be able to do transacions from the beginning
    function deposit() payable public{
        
    }
}
