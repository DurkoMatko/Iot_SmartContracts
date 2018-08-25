pragma solidity ^0.4.0;

contract Group{
    
    struct Person {
        string name;
        uint age;
    }
    
    Person[] people;
    
    function addPerson(string _name, uint _age){
        people.push(Person(_name,_age));
    }
    
    function getAgeAverage() returns (uint) {
        uint sum;
        for (uint i=0; i<people.length; i++) {
            sum += people[i].age;
        }
        return sum/people.length;
    }
}
