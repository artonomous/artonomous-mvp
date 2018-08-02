var ArtonomousStaking = artifacts.require("./ArtonomousStaking.sol");
var Artonomous = artifacts.require("./Artonomous.sol");

module.exports = function(deployer, network, accounts) {
  let beneficiary = accounts[0];
  deployer.deploy(Artonomous, ArtonomousStaking.address, beneficiary);
};
