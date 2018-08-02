var ArtonomousStaking = artifacts.require("./ArtonomousStaking.sol");

module.exports = function(deployer) {
  deployer.deploy(ArtonomousStaking, "55f74ddc033dc34ca3b11ece54e6e569c24ea7da");
};
