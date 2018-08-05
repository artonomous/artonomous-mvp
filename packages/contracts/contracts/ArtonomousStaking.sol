pragma solidity ^0.4.24; //solhint-disable-line compiler-fixed

/*
In the hardcoded version, there is a hardcoded generator hash.
Keeping this scaffolding out for more easily implementing into shifting or multiple generators
*/

contract ArtonomousStaking {
    string public currentGeneratorHash;

    constructor(string _initialGenerator) public {
        currentGeneratorHash = _initialGenerator;
    }
}
