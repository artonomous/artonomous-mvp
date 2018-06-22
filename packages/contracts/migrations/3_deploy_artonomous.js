var ArtonomousStaking = artifacts.require("./ArtonomousStaking.sol");
var Artonomous = artifacts.require("./Artonomous.sol");

module.exports = function(deployer, network, accounts) {
  let beneficiary = accounts[0];
  deployer.deploy(Artonomous, ArtonomousStaking.address, beneficiary);
  web3.eth.sendTransaction({
    from: accounts[0],
    to: "0xcec56f1d4dc439e298d5f8b6ff3aa6be58cd6fdf",
    value: "10000000000000000000"
  });
};
