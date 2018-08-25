pragma solidity ^0.4.0;

contract BankContract{
    uint balance;
    
    function deposit() payable {
        balance += msg.value;
    }
    
    //type view says it doesn't effect any variable in the contract
    //this doesn't require a blockchain transaction (nothing is being changed, we don't need to write anything to blockchain)
    function getBalance() view returns (uint) {
         return balance;
    }
    
}
