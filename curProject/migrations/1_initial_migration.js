var Migrations = artifacts.require("./TokenTransaction.sol");
module.exports = function(deployer) {
  deployer.deploy(Migrations);

};
