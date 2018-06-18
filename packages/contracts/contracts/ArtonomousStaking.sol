pragma solidity ^0.4.23;

contract ArtonomousStaking {
    string public currentGeneratorHash;

    constructor(string _initialGenerator) public {
        currentGeneratorHash = _initialGenerator;
    }
}
