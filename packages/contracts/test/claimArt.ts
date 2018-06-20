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
        it ("fails if other contract just deployed", async () => {
            await expect(artonomous.claimArt()).to.eventually.be.rejectedWith("revert", "should not have allowed user to claim art immediately after contract deployed");
        });
        it ("succeeds if contract was deployed 24 hours ago", async () => {
            await advanceEvmTime(86401); // just over 24 hours
            await expect(artonomous.claimArt()).to.eventually.be.fulfilled("should have allowed user to claim art 24 hours after contract deployed");
        });
        it ("fails if previous auction was just ended (by claim) and new auction just began", async () => {
            await advanceEvmTime(86401); // just over 24 hours
            await expect(artonomous.claimArt()).to.eventually.be.fulfilled("should have allowed user to claim art 24 hours after contract deployed");
            await expect(artonomous.claimArt()).to.eventually.be.rejectedWith("revert", "should not have allowed user to claim art immediately after previous auction ended (and new one started)");
        });
        it ("succeeds if new auction began 24 hours ago", async () => {
            await advanceEvmTime(86401); // just over 24 hours
            await expect(artonomous.claimArt()).to.eventually.be.fulfilled("should have allowed user to claim art 24 hours after contract deployed");
            await advanceEvmTime(86401); // just over 24 hours
            await expect(artonomous.claimArt()).to.eventually.be.fulfilled("should have allowed user to claim art 24 hours after initial auction finished and new one started");
        });
    });
});
