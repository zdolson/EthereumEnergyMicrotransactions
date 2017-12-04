var Migrations = artifacts.require("./Migrations.sol") ; 
var Mig = artifacts.require("./TokenTransaction.sol") ; 
module.exports = function(deployer) {
    deployer.deploy(Migrations);
    deployer.deploy(Mig) ;  
};
