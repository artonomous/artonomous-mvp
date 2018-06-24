pragma solidity ^0.4.24;

import "./ArtonomousStaking.sol";
import "./ArtonomousArtPieceToken.sol";

contract Artonomous {

    event ArtonomousAuctionStarted(uint indexed blockNumber, string generatorHashUsed);
    event ArtonomousArtBought(address indexed buyer, uint indexed blockNumber, uint price);
    event ArtonomousArtClaimed(address indexed claimant, uint indexed blockNumber);

    struct Auction {
        uint blockNumber;
        uint endTime;
        uint startingPrice;
    }

    ArtonomousStaking public artonomousStaking;
    ArtonomousArtPieceToken public pieceToken;
    address public beneficiary; // receives ether gained from purchases

    uint public AUCTION_LENGTH = 86400; // 24 hours
    Auction currentAuction;

    constructor(address stakingAddr, address beneficiaryAddr) public {
        artonomousStaking = ArtonomousStaking(stakingAddr);
        pieceToken = new ArtonomousArtPieceToken("artonomous-token", "ARTO");
        beneficiary = beneficiaryAddr;
        startAuction();
    }

    function startAuction() internal {
        require(currentAuction.blockNumber == 0);
        string memory currentGeneratorHash = artonomousStaking.currentGeneratorHash();
        pieceToken.mint(this, block.number, currentGeneratorHash);
        currentAuction = Auction({
            blockNumber: block.number,
            endTime: now + AUCTION_LENGTH,
            startingPrice: getStartingPrice()
        });
        emit ArtonomousAuctionStarted(block.number, currentGeneratorHash);
    }

    // placeholder
    function getStartingPrice() internal pure returns (uint) {
        return 1000000000000;
    }

    function buyArt() external payable {
        uint blockNumber = currentAuction.blockNumber;
        require(blockNumber > 0);
        require(currentAuction.endTime > now);

        uint buyPrice = getBuyPrice(currentAuction.startingPrice);
        require(msg.value >= buyPrice);


        pieceToken.transferFrom(this, msg.sender, blockNumber);
        delete currentAuction;

        uint remainder = msg.value - buyPrice;
        msg.sender.transfer(remainder); // refund extra
        beneficiary.transfer(buyPrice); // pay Artonomous' beneficiary

        emit ArtonomousArtBought(msg.sender, blockNumber, buyPrice);

        startAuction();
    }

    // placeholder
    function getBuyPrice(uint startingPrice) internal pure returns (uint) {
        return startingPrice;
    }

    // after 24 hours, anyone can claim for free
    function claimArt() external {
        uint blockNumber = currentAuction.blockNumber;
        require(blockNumber > 0);
        require(currentAuction.endTime <= now);

        pieceToken.transferFrom(this, msg.sender, blockNumber);
        delete currentAuction;

        emit ArtonomousArtClaimed(msg.sender, blockNumber);

        startAuction();
    }
}
