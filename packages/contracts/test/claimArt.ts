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

    describe ("claimArt", () => {
        it ("fails if no auction in progress", async () => {
            await expect(artonomous.claimArt()).to.eventually.be.rejectedWith("revert", "should have failed with no auction in progress");
        });
        it ("fails if other auction just started", async () => {
            await expect(artonomous.startAuction()).to.eventually.be.fulfilled("should have allowed auction to being immediately after contract deployed");
            await expect(artonomous.claimArt()).to.eventually.be.rejectedWith("revert", "should not have allowed user to claim art immediately after auction started");
        });
        it ("succeeds if other auction was started 24 hours ago", async () => {
            await expect(artonomous.startAuction()).to.eventually.be.fulfilled("should have allowed auction to being immediately after contract deployed");
            await advanceEvmTime(86401); // just over 24 hours
            await expect(artonomous.claimArt()).to.eventually.be.fulfilled("should have allowed user to claim art 24 hours after auction started");
        });
    });
});
