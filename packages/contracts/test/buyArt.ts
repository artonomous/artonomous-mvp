import * as chai from "chai";
import { advanceEvmTime, configureChai } from "../scripts/testHelpers";

const Artonomous = artifacts.require("Artonomous");
const ArtonomousStaking = artifacts.require("ArtonomousStaking");
const ArtonomousArtPieceToken = artifacts.require("ArtonomousArtPieceToken");

configureChai(chai);
const expect = chai.expect;

contract("Artonomous", accounts => {
  let staking: any;
  let artonomous: any;

  beforeEach(async () => {
    staking = await ArtonomousStaking.new(
      "55f74ddc033dc34ca3b11ece54e6e569c24ea7da"
    );
    const stakingAddr = staking.address;
    artonomous = await Artonomous.new(stakingAddr, accounts[0]);
  });

  describe("buyArt", () => {
    it("fails if other contract just deployed and no ETH sent", async () => {
      await expect(artonomous.buyArt()).to.eventually.be.rejectedWith(
        "revert",
        "should not have allowed user to buy art without sending enough ETH"
      );
    });
    it("fails if contract was deployed over 24 hours ago and no ETH sent", async () => {
      await advanceEvmTime(86401); // just over 24 hours
      await expect(artonomous.buyArt()).to.eventually.be.rejectedWith(
        "revert",
        "should not have allowed user to buy art after end of auction and without sending enough ETH"
      );
    });

    it("succeeds if other contract just deployed and exactly enough ETH sent", async () => {
      await expect(
        artonomous.buyArt({ value: 1000000000000 })
      ).to.eventually.be.fulfilled(
        "should have allowed user to buy art with exactly enough ETH sent"
      );
    });

    it("succeeds if other contract just deployed and more than enough ETH sent", async () => {
      await expect(
        artonomous.buyArt({ value: 2000000000000 })
      ).to.eventually.be.fulfilled(
        "should have allowed user to buy art with more than enough ETH sent"
      );
    });

    it("fails if other contract just deployed and not enough ETH sent", async () => {
      await expect(
        artonomous.buyArt({ value: 100000000000 })
      ).to.eventually.be.rejectedWith(
        "revert",
        "should not have allowed user to buy art without sending enough ETH"
      );
    });

    it("fails if contract was deployed over 24 hours ago and enough ETH sent", async () => {
      await advanceEvmTime(86401); // just over 24 hours
      await expect(
        artonomous.buyArt({ value: 1000000000000 })
      ).to.eventually.be.rejectedWith(
        "revert",
        "should not have allowed user to buy art after end of auction and without sending enough ETH"
      );
    });

    it("succeeds if previous auction was just ended (by claim) and new auction just began", async () => {
      await advanceEvmTime(86401); // just over 24 hours
      await expect(artonomous.claimArt()).to.eventually.be.fulfilled(
        "should have allowed user to claim art 24 hours after contract deployed"
      );
      await expect(
        artonomous.buyArt({ value: 1000000000000 })
      ).to.eventually.be.fulfilled(
        "should have allowed user to buy art immediately after previous auction ended (and new one started)"
      );
    });

    it("succeeds if previous auction was just ended (by buying) and new auction just began", async () => {
      await expect(
        artonomous.buyArt({ value: 1000000000000 })
      ).to.eventually.be.fulfilled(
        "should have allowed user to buy art immediately after contract deployed"
      );
      await expect(
        artonomous.buyArt({ value: 1000000000000 })
      ).to.eventually.be.fulfilled(
        "should have allowed user to buy art immediately after previous auction ended (and new one started)"
      );
    });

    it("fails if new auction began 24 hours ago", async () => {
      await advanceEvmTime(86401); // just over 24 hours
      await expect(artonomous.claimArt()).to.eventually.be.fulfilled(
        "should have allowed user to claim art 24 hours after contract deployed"
      );
      await advanceEvmTime(86401); // just over 24 hours
      await expect(
        artonomous.buyArt({ value: 1000000000000 })
      ).to.eventually.be.rejectedWith(
        "revert",
        "should not have allowed user to buy art 24 hours after initial auction finished and new one started"
      );
    });

    it("fails if trying to mint from anyone else besides Artonomous", async() => {
      const pieceTokenAddress = await artonomous.pieceToken.call();
      const pieceTokenContract = ArtonomousArtPieceToken.at(pieceTokenAddress);
      await expect(
        pieceTokenContract.mint(100, "hash")
      ).to.eventually.be.rejectedWith(
        "revert",
        "should not be allowed to mint artwork by anyone else besides artonomous"
      );
    });
  });
});
