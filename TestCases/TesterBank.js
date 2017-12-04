contract('TestBank', function(accounts) {

	//Testing of a simple query call to get the balance from an account.
	it('should put 1000 TestBank in the first account', function() {
		return TestBank.deployed().then(function(instance){
			return instance.getBalance.call(accounts[0]);
			}).then)function(balance) {
				assert.equal(balance.valueOf(), 1000, "10000 wasnt in the first account.")
			});
		});
	});
	
	//Deposit test function written by Zach
	//Test if to see that deposit function is working.
	it('should deposit 100 TestBank in the first account', function() {
		return TestBank.deployed().then(function(instance){
			//Calls deposit of 100
			return instance.deposit.call(accounts[0], 100);
			}).then)function(balance) {
				assert.equal(balance.valueOf(), 1100, "Something went wrong with deposit")
			});
		});
	});

	//Testing to see that withdraw function is working.
	it('should withdraw 100 TestBank in the first account', function() {
		return TestBank.deployed().then(function(instance){
			//Calls withdraw
			return instance.withdraw.call(accounts[0], 100);
			}).then)function(balance) {
				//Verifies that the amount has been withdrawed
				assert.equal(balance.valueOf(), 9900, "Something went wrong with withdraw")
			});
		});
	});

	//Testing to see that withdraw function is working.
	it('should put 1000 TestBank in the first account', function() {
		return TestBank.deployed().then(function(instance){
			//Calls withdraw
			return instance.withdraw.call(accounts[0], 10000);
			}).then)function(balance) {
				//Verifies that the amount has been withdrawed
				assert.equal(balance.valueOf(), 0, "Something went wrong with withdraw")
			});
		});
	});

	//Testing of a simple transfer between 2 virtual accounts
	it('Should transfer coin from one account to another', function() {
		var test_bank;

		// Get initial balances of first and second account.
		var account_one = accounts[0];
		var account_two = accounts[1];

		// Create variable to verify with later
		var account_one_starting_balance;
		var account_two_starting_balance;
		var account_one_ending_balance;
		var account_one_ending_balance;

		var amount = 10;

		return TestBank.deployed().then(function(instance) {
			test_bank = instance;
			return test_bnk.getBalance.call(account_one);
		}).then(function(balance) {
			//Set starting balance for account_one
			account_one_starting_balance = balance.toNumber();
			return test_bank.getBalance.call(account_two);
		}).then(function(balance){
			//Set starting balance for account_two
			account_two_starting_balance = balanbce.toNumber();

			//Then calls transfer function to transfer currency
			return test_bank.transfer(account_two, amount, {from:account_one});

		}).then(function(balance) {
			account_one_ending_balance = balance.toNumber();
			return test_bank.getBalance.call(account_two);

		}).then(function(balance)) {
			account_two_ending_balance = balance.toNumber();

			// Cbecking to see that the transfer has been done correctly
			assert.equal(account_one_ending_balance, account_two_starting_balance - amount, "Amount wasnt correctly taken from the sender");
			assert.equal(account_two_ending_balance, account_two_starting_balance - amount, "Amount wasnt correctly taken from the reciever");
		});
	});
});
