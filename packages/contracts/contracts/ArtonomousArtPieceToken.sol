pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";

contract ArtonomousArtPieceToken is ERC721Token {

    mapping(uint => bytes32) public blockNumberToGeneratorUsed;

    constructor(string name, string symbol) public ERC721Token(name, symbol) {
    }

    function mint(address beneficiary, uint _block, bytes32 _generator) public {
        _mint(beneficiary, _block);
        blockNumberToGeneratorUsed[_block] = _generator;
    }
}
