var GuessCore = artifacts.require("./GuessCore.sol");

module.exports = function(deployer) {

  console.log(GuessCore);
  
  deployer.deploy(GuessCore);
};