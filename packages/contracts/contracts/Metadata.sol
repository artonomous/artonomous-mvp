pragma solidity ^0.4.18;

/**
* Metadata contract is upgradeable and returns metadata about NFT
* This could also be used to create a json object as a string and return the actual metadata directly
*/

import "./helpers/strings.sol";


contract Metadata {
    using strings for *;

    function tokenMetadata(uint _tokenId) public view returns (string _infoUrl) {
        string memory base = "https://artonomous.ai/metadata/";
        string memory id = bytes32ToString(bytes32(_tokenId));
        string memory suffix = ".json";
        return base.toSlice().concat(id.toSlice()).toSlice().concat(suffix.toSlice());
    }

    function bytes32ToString (bytes32 data) returns (string) {
        bytes memory bytesString = new bytes(32);
        for (uint j=0; j < 32; j++) {
            byte char = byte(bytes32(uint(data) * 2 ** (8 * j))); // ?? is still the most efficient way. you can index a bytes32 these days?
            if (char != 0) {
                bytesString[j] = char;
            }
        }
        return string(bytesString);
    }
}
