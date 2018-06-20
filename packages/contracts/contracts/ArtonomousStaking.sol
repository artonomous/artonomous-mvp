pragma solidity ^0.4.24;

contract ArtonomousStaking {
    string public currentGeneratorHash;

    constructor(string _initialGenerator) public {
        currentGeneratorHash = _initialGenerator;
    }
}
