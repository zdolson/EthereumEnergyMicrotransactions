var trans = artifacts.require("./TokenTransaction.sol");
var factory = artifacts.require("TransactionFactory");
contract('trans', function(accounts) {
    it("should put in the first account", function() {
        var action = trans.deployed();
        action.then(function(instance) { instance.isRegistered("kevin").then(console.log("checked"));});
  });
});

contract('trans', function(accounts) {
    it("testing 4 accounts and create transaction contract", function() {
        var action = trans.deployed();
        action.then(function(instance) { 
            instance.register(accounts[0], "David")
            instance.register(accounts[1], "Nick")
            instance.register(accounts[2], "Zack")
            instance.register(accounts[3], "Kevin")            
        }).then(function() { 
            console.log("here");

            //creating a contract here to trade between David and Nick
            var contractAddr = instance.createTransaction("Testing Contract").then(console.log);
            let transferEvent = action.Action({}, {fromBlock: 0, toBlock: 'latest'})
            transferEvent.get((error, logs) => { 
                logs.forEach(log => console.log(log.args));
            });
            // does it exist or the name? 
            instance.getContract("Testing");
            var contractInstace = TokenTransaction.new(instance.getContract("Testing"));
            contractInstance

        });
        // action.then(function(instance) { instance.isRegistered("kevin").then(console.log).then(console.log("checked"));});
  });
  it("done YEAH", function async() {
        console.log("yeah, end");
  });
});