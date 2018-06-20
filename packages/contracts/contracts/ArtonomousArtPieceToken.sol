pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";

contract ArtonomousArtPieceToken is ERC721Token {

    constructor(string name, string symbol) public ERC721Token(name, symbol) {
    }

    function mint(address beneficiary, uint _block, string _generator) public {
        _mint(beneficiary, _block);
        _setTokenURI(_block, _generator);
    }
}
