pragma solidity ^0.4.0;
import "./DogContract.sol";

//interface of another contract (which is on blockchain already and I don't have access to its file so I can't import it)
//interfaces are used to interact with external contracts
contract BankInterface{
    function getBalance() view returns (uint);
    function deposit() payable;
}

contract Kennel is DogContract {
    
    //throws error when not enough value is send
    modifier costs_require(uint value){
        require(msg.value >= value);
        _; //this means "OK, continue with the function execution"
    }
    
    //just doesn't execute the function if not enough value is send
    modifier costs(uint value){
        if(msg.value >= value){
            _; //this means "OK, continue with the function execution"
        }
    }
    
    //I copied an address of deployed BankContract
    address externalAddress = 0x3c210e984182c331873e235e2fb084188c53941c;
    BankInterface BankContract = BankInterface(externalAddress);
    
    //payable function means we can send money with it
    //this money is stored in the contract's address (each contract has its own unique ethereum address)
    function transferDog(address _newOwner) payable costs(100) {
        require (msg.sender != _newOwner);
        uint dogId = ownerToDog[msg.sender];
        delete(ownerToDog[msg.sender]);
        ownerToDog[_newOwner] = dogId;
        
        //ensure that I have no more dog
        //asser also burns all the gas left in the function
        assert(ownerToDog[msg.sender] == 0);
        
        //sending 100wei I got to this Kennel contract to an external Bank Contract
        BankContract.deposit.value(msg.value)();
    }
    
    function addKennelDog(string _name, uint _age) payable costs(50) {
        addDog(_name, _age);
    }
    
    function getBankBalance() view returns(uint){
        return BankContract.getBalance();
    }
}
