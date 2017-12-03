var Migrations = artifacts.require("./TokenExchange.sol");
module.exports = function(deployer) {
  deployer.deploy(Migrations);
};