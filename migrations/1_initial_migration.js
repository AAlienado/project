var Token = artifacts.require("./TokenNET.sol");

module.exports = function(deployer) {
  deployer.deploy(Token);
};