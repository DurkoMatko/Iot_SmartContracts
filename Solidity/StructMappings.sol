pragma solidity ^0.4.0;

contract DogContract{
    
    struct Dog {
        string name;
        uint age;
    }
    
    Dog[] dogNames;
    mapping(address => uint) ownerToDog;
    
    function addDog(string _name, uint _age){
        address owner = msg.sender;
        uint id = dogNames.push(Dog(_name,_age));
        ownerToDog[owner] = id;
    }
    
    function getDog() returns (string) {
        uint sendersDogId = ownerToDog[msg.sender];
        
        //mappings are not zero indexed, so I have to substract -1 because arrays are
        return dogNames[sendersDogId-1].name;
    }
}
