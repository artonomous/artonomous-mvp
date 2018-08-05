pragma solidity ^0.4.24; //solhint-disable-line compiler-fixed

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

    uint public constant AUCTION_LENGTH = 86400; // 24 hours
    Auction public currentAuction;

    constructor(address stakingAddr, address beneficiaryAddr) public {
        artonomousStaking = ArtonomousStaking(stakingAddr);
        pieceToken = new ArtonomousArtPieceToken("artonomous-hardcoded-works", "ARTHC");
        beneficiary = beneficiaryAddr; // beneficiary is the curved bond contract.
        startAuction();
    }

    function buyArt() external payable {
        uint blockNumber = currentAuction.blockNumber;
        require(blockNumber > 0);
        require(currentAuction.endTime > now); //solhint-disable-line not-rely-on-time

        uint buyPrice = getBuyPrice(currentAuction.startingPrice);
        require(msg.value >= buyPrice);

        pieceToken.transferFrom(this, msg.sender, blockNumber);
        delete currentAuction;

        uint remainder = msg.value - buyPrice;
        if (remainder > 0) {
            msg.sender.transfer(remainder); // refund extra
        }
        beneficiary.transfer(buyPrice); // pay Artonomous' beneficiary. Its curved bond.

        emit ArtonomousArtBought(msg.sender, blockNumber, buyPrice);

        startAuction();
    }

    // after 24 hours, anyone can claim for free
    function claimArt() external {
        uint blockNumber = currentAuction.blockNumber;
        require(blockNumber > 0);
        require(currentAuction.endTime <= now); //solhint-disable-line not-rely-on-time

        pieceToken.transferFrom(this, msg.sender, blockNumber);
        delete currentAuction;

        emit ArtonomousArtClaimed(msg.sender, blockNumber);

        startAuction();
    }

    function startAuction() internal {
        require(currentAuction.blockNumber == 0);
        string memory currentGeneratorHash = artonomousStaking.currentGeneratorHash();
        pieceToken.mint(block.number, currentGeneratorHash); // create art piece
        currentAuction = Auction({
            blockNumber: block.number,
            endTime: now + AUCTION_LENGTH, //solhint-disable-line not-rely-on-time
            startingPrice: getStartingPrice()
        });
        emit ArtonomousAuctionStarted(block.number, currentGeneratorHash);
    }

    // placeholder
    // todo: starting price should shift/change based on previous art sold.
    function getStartingPrice() internal pure returns (uint) {
        return 1000000000000;
    }

    // placeholder
    // todo: buy price should, based on time, go down to zero.
    function getBuyPrice(uint startingPrice) internal pure returns (uint) {
        return startingPrice;
    }
}
