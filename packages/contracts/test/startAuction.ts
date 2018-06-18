import * as chai from "chai";
import { advanceEvmTime, configureChai } from "../scripts/testHelpers";

const Artonomous = artifacts.require("Artonomous");
const ArtonomousStaking = artifacts.require("ArtonomousStaking");

configureChai(chai);
const expect = chai.expect;

contract ("Artonomous", accounts => {
    let staking: any;
    let artonomous: any;

    beforeEach (async () => {
        staking = await ArtonomousStaking.new("55f74ddc033dc34ca3b11ece54e6e569c24ea7da")
        const stakingAddr = staking.address;
        artonomous = await Artonomous.new(stakingAddr);
    });

    describe ("startAuction", () => {
        it ("works after contract deployed", async () => {
            await expect(artonomous.startAuction()).to.eventually.be.fulfilled("should have allowed auction to begin immediately after contract deployed");
        });
        it ("fails if other auction is in progress", async () => {
            await expect(artonomous.startAuction()).to.eventually.be.fulfilled("should have allowed auction to begin immediately after contract deployed");
            await expect(artonomous.startAuction()).to.eventually.be.rejectedWith("revert", "should not have allowed auction to start with one already in progress");
        });
        it ("succeeds if other auction was started and ended", async () => {
            await expect(artonomous.startAuction()).to.eventually.be.fulfilled("should have allowed auction to begin immediately after contract deployed");
            await advanceEvmTime(86401); // just over 24 hours
            await expect(artonomous.claimArt()).to.eventually.be.fulfilled("should have allowed user to claim art 24 hours after auction started");
            await expect(artonomous.startAuction()).to.eventually.be.fulfilled("should have allowed auction to begin after previous auction has ended");
        });
    });
});
