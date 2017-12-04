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
            instance.depositEnits("David", 10).then(instance.getBalance("David").log());
            var balance = instance.getBalance("David").call();
            assert(balance == 10);
            console.log(balance);
            console.log("done");
        }).then(function() { 
            assert(instance.getBalance("David") > instance.getBalance("Nick"));  
        });
        // action.then(function(instance) { instance.isRegistered("kevin").then(console.log).then(console.log("checked"));});
  });
  it("testing exchange here now", function() {
      trans.deployed().then(function(instance) { 
        instance.register(accounts[0], "David")
        instance.register(accounts[1], "Nick")
      }).then(function() { 
        instance.depositEnits("David", 10)
        instance.depositEnits("Nick", 20)
        assert(instance.getBalance("David") == 10)
        assert(instance.getBalance("Nick") == 20)
      }).then(function() {
          instance.transferEnergy1("David", "Nick", 5)
          assert(getBalance("David") == 15)
          assert(getBalance("Nick") == 15)
      })
  })
  it("done YEAH", function async() {
        console.log("yeah, end");
  });
});``