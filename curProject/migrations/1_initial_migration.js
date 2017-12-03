var Migrations = artifacts.require("./Migrations.sol") ; 
var Mig = artifacts.require("./TransactionFactory.sol");
module.exports = function(deployer) {
    deployer.deploy(Migrations);
    deployer.deploy(Mig) ;  

};
