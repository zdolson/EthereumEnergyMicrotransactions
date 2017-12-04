var trans = artifacts.require("./TokenTransaction.sol");
/*
	To run tests:
		in a seperate console tab: test rpc -> make sure it runs. 
		-> truffle console
		-> truffle migrate
		-> var accounts = web3.eth.accounts

		truffle test /path/to/testbank.js

	* NOTE *  Each group member wrote a unit test for this project/contract. The other test file is test.js in the github repo. 
*/

contract('TokenTransaction', function(accounts) {

	// Testing of a simple query call to get the balance from an account.
  	it("should get the balance of 0 from the first account", function() {
    	var action = trans.deployed();
  		action.then(function(instance) {
  		    instance.register(accounts[0], "Nicholas")
        })
  		return trans.deployed().then(function(instance) {
  			// Calls deposit of 100
  	  		return instance.setBalance(accounts[0], 0, true);
  		
  			// Verifies that the amount has been deposited.
  			requires(instance.getBalance("Nicholas"), 0, "getBalance is not working correctly");
		});
  	});

  	// Written by Kevin Serrano 
  	// module is TransactionFactory 
  	// the equivalence classes are 100 and -100 to see if 
  	// the balance are set or not.
  	it("Testing setBalance with a true flag therefore will add to the account.", function() {
  		var action = trans.deployed();
  		action.then(function(instance) {
  		    instance.register(accounts[0], "Nicholas")
        })
  		return trans.deployed().then(function(instance) {
  			// Calls deposit of 100
  	  		return instance.setBalance(accounts[0], 100, true);
  		
  			// Verifies that the amount has been deposited.
  			requires(instance.getBalance("Nicholas"), 100, "Will not setBalance.");
		});
  	});

  	it("Testing setBalance with a false flag therefore will add to the account.", function() {
  		var action = trans.deployed();
  		action.then(function(instance) {
  		    instance.register(accounts[0], "Nicholas")
        })
  		return trans.deployed().then(function(instance) {
  			// Calls deposit of 100
  	  		return instance.setBalance(accounts[0], 100, false);
  		
  			// Verifies that the amount has been deposited.
  			requires(instance.getBalance("Nicholas"), -100, "Will not setBalance.");
		});
  	});


  	it("Testing register()", function() { 
  		return trans.deployed().then(function(instance) {
  			if (instance.register(accounts[0], "Nicholas") == true){
  				console.log('Register is working')
  			} else {
  				console.log('Register is not working')
  			}
		});
  	});

  	it("Testing isRegistered()", function() {
  		return trans.deployed().then(function(instance) {
  			instance.register(accounts[0], "Nicholas");
  			if (instance.isRegistered("Nicholas")){
  				console.log('isRegistered is working!')
  			} else {
  				console.log('isRegistered is not working')
  			}
		});
  	});

	// Written by Nicholas Cheung  	
	// the module is TransactionFactory in this case 
	// the equivalence classes are the values from KWH and Ether, 3460 to 1.
  	it("Testing convertToken()", function() {
  		var action = trans.deployed();
        action.then(function(instance) {
        	instance.register(accounts[0], "David");
  		
  			var test_val_1 = 1
  			var test_val_2 = 3460

  			assert.equal(trans.convertToken(true, test_val_1), 3460, 'Didnt covert correctly');
  			assert.equal(trans.convertToken(false, test_val_2), 1, 'Didnt convert correctly');
		});
  	});

});

