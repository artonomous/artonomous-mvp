pragma solidity ^0.4.23;

import "./ArtonomousStaking.sol";
import "./ArtonomousArtPieceToken.sol";

contract Artonomous {

    event ArtonomousAuctionStarted(uint indexed blockNumber, bytes32 generatorHashUsed);
    event ArtonomousArtClaimed(address indexed claimant, uint indexed blockNumber, bytes32 generatorHashUsed);

    struct Auction {
        uint blockNumber;
        bytes32 generatorHash;
        uint endTime;
    }

    ArtonomousStaking public artonomousStaking;
    ArtonomousArtPieceToken public pieceToken;
    uint public AUCTION_LENGTH = 86400; // 24 hours
    Auction currentAuction;

    constructor(address stakingAddr) public {
        artonomousStaking = ArtonomousStaking(stakingAddr);
        pieceToken = new ArtonomousArtPieceToken("artonomous-token", "ARTO");
    }

    function startAuction() external {
        require(currentAuction.blockNumber == 0);
        bytes32 currentGeneratorHash = artonomousStaking.currentGeneratorHash();
        currentAuction = Auction({
            blockNumber: block.number,
            generatorHash: currentGeneratorHash,
            endTime: now + AUCTION_LENGTH
        });
        emit ArtonomousAuctionStarted(block.number, currentGeneratorHash);
    }

    // after 24 hours, anyone can claim for free
    function claimArt() external {
        uint blockNumber = currentAuction.blockNumber;
        bytes32 generator = currentAuction.generatorHash; 
        require(blockNumber > 0);
        require(currentAuction.endTime < now);

        pieceToken.mint(msg.sender, blockNumber, generator);

        delete currentAuction;

        emit ArtonomousArtClaimed(msg.sender, blockNumber, generator);
    }
}
