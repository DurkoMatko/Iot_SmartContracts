pragma solidity ^0.4.0;

contract Person {
    
    string name;
    uint128 age;
    
    function getName() view returns (string) {
        return name;
    }
    
    function setName(string _name){
        name = _name;
    } 
    
    function getAge() view returns (uint128) {
        return age;
    }
    
    function setAge(uint128 _age){
        age = _age;
    } 
    
   
}
