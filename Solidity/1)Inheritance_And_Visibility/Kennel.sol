pragma solidity ^0.4.0;
import "./DogContract.sol";

contract Kennel is DogContract {
    
    function transferDog(address _newOwner){
        uint dogId = ownerToDog[msg.sender];
        delete(ownerToDog[msg.sender]);
        ownerToDog[_newOwner] = dogId;
    }
    
    function addKennelDog(string _name, uint _age) {
        addDog(_name, _age);
    }
}
