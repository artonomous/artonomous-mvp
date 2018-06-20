pragma solidity ^0.4.24;

import "./ArtonomousStaking.sol";
import "./ArtonomousArtPieceToken.sol";

contract Artonomous {

    event ArtonomousAuctionStarted(uint indexed blockNumber, string generatorHashUsed);
    event ArtonomousArtClaimed(address indexed claimant, uint indexed blockNumber);

    struct Auction {
        uint blockNumber;
        uint endTime;
    }

    ArtonomousStaking public artonomousStaking;
    ArtonomousArtPieceToken public pieceToken;
    uint public AUCTION_LENGTH = 86400; // 24 hours
    Auction currentAuction;

    constructor(address stakingAddr) public {
        artonomousStaking = ArtonomousStaking(stakingAddr);
        pieceToken = new ArtonomousArtPieceToken("artonomous-token", "ARTO");
        startAuction();
    }

    function startAuction() internal {
        require(currentAuction.blockNumber == 0);
        string memory currentGeneratorHash = artonomousStaking.currentGeneratorHash();
        pieceToken.mint(this, block.number, currentGeneratorHash);
        currentAuction = Auction({
            blockNumber: block.number,
            endTime: now + AUCTION_LENGTH
        });
        emit ArtonomousAuctionStarted(block.number, currentGeneratorHash);
    }

    // after 24 hours, anyone can claim for free
    function claimArt() external {
        uint blockNumber = currentAuction.blockNumber;
        require(blockNumber > 0);
        require(currentAuction.endTime < now);

        pieceToken.transferFrom(this, msg.sender, blockNumber);

        delete currentAuction;

        emit ArtonomousArtClaimed(msg.sender, blockNumber);

        startAuction();
    }
}
