var trans = artifacts.require("./TokenTransaction.sol");
var factory = artifacts.require("TransactionFactory");
contract('trans', function(accounts) {
    it("should put in the first account", function() {
        var action = trans.deployed();
        action.then(function(instance) { instance.isRegistered("kevin").then(console.log("checked"));});
  });
});

contract('trans', function(accounts) {
    it("testing 4 accounts", function() {
        var action = trans.deployed();
        action.then(function(instance) { 
            instance.register(accounts[0], "David")
            instance.register(accounts[1], "Nick")
            instance.register(accounts[2], "Zack")
            instance.register(accounts[3], "Kevin")            
        }).then(function() { 
            console.log("here");
            instance.depositEnits("David", 10).then(instance.getBalance("David").then(console.log));
            var balance = instance.getBalance("David").call();
            console.log(balance);
            console.log("done");
        });
        // action.then(function(instance) { instance.isRegistered("kevin").then(console.log).then(console.log("checked"));});
  });
  it("done YEAH", function async() {
        console.log("yeah, end");
  });
});``