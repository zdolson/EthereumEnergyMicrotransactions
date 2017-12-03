action.then(function(instance) { contractInstance = TokenTransaction.new(instance.getContract("Hi")).then(contractInstance.depositEnits(10, {from: a1}));});

var a = TransactionFactory.deployed(); var a1 = web3.eth.accounts[0]; var a2 = web3.eth.accounts[1]; var contractInstance; var myContract;
a.then(function(instance) { instance.register(a1, "d").then(instance.register(a2, "n")); });

a.then(function(instance) { contractInstance = instance.createTransaction("Hi").then(console.log).then(function() { instance.getContract("Hi").then(console.log) ;});});
a.then(function(instance) { instance.getContract("Hi").then(console.log)});
a.then(function(instance) { myContract = TokenTransaction.at(instance.getContract("Hi")) });`