var GuessCore = artifacts.require("./GuessCore.sol");
var UTOToken = artifacts.require("./UTOToken.sol")

module.exports = function(deployer) {

  deployer.deploy(UTOToken);
  deployer.deploy(GuessCore);
  
};