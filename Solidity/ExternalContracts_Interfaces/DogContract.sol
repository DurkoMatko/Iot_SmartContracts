pragma solidity ^0.4.0;

contract DogContract{
    
    struct Dog {
        string name;
        uint age;
    }
    
    Dog[] dogNames;
    mapping(address => uint) ownerToDog;
    
    //frontend dapps can bind on events (they are listed in logs of a transaction so dapps see them when connected to blockchain)
    event addedDog(address owner, string name, uint dogId);
    
    function addDog(string _name, uint _age) internal{
        address owner = msg.sender;
        uint id = dogNames.push(Dog(_name,_age));
        ownerToDog[owner] = id;
        //trigger event
        emit addedDog(owner, _name, id);
    }
    
    function getDog() returns (string) {
        uint sendersDogId = ownerToDog[msg.sender];
        
        //mappings are not zero indexed, so I have to substract -1 because arrays are
        return dogNames[sendersDogId-1].name;
    }
}
