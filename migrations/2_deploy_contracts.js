var GuessCore = artifacts.require("./GuessCore.sol");

module.exports = function(deployer) {
  deployer.deploy(GuessCore);
};