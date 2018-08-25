pragma solidity ^0.4.0;
import "./DogContract.sol";

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
    }
    
    function addKennelDog(string _name, uint _age) payable costs(50) {
        addDog(_name, _age);
    }
}
