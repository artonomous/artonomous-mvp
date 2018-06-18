pragma solidity ^0.4.23;

contract ArtonomousStaking {
    bytes32 public currentGeneratorHash;

    constructor(bytes32 _initialGenerator) public {
        currentGeneratorHash = _initialGenerator;
    }
}
