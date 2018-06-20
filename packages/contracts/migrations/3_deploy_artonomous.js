var ArtonomousStaking = artifacts.require("./ArtonomousStaking.sol");
var Artonomous = artifacts.require("./Artonomous.sol");

module.exports = function(deployer) {
  deployer.deploy(Artonomous, ArtonomousStaking.address);
};
