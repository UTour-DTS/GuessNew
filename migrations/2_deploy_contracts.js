var GuessBids = artifacts.require("./GuessBids.sol");

module.exports = function(deployer) {
  
  deployer.deploy(GuessBids);
  
};