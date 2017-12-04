pragma solidity ^0.4.4;
/* This smart contract was originally for sprint 2 as a test to understand 
 * how smart contract works. It is not in use anymore but it is here 
 * as documentation now. Shows us how much we don't know about blockchaining 
 * and the technologies around it.
 */ 
contract TestBank {

	address owner;

	//Example call -> TestBank.deployed().then(function(instance) { instance.getBalance(balances[0])})

	// Somewhat like a hashtable of addresses/balances
	mapping (address => uint) balances;

	// Logs the transfer to blockchain
	event Transfer(address indexed _from, address indexed _to, uint256 _value);

	function TestBank(){
		owner = msg.sender;

		//tx.origin -> getting original caller's information. Owner can NOT be a contract
		//msg.sender -> owner can be a contract
		balances[tx.origin] = 10000;
	}

	// Returns current balance in a specific account
	function getBalance(address addr) returns (uint) {
		return balances[addr];
	}

	function deposit(address addr, uint value) returns(uint new_value) {
		balances[msg.sender] += msg.value;
		return balances[addr];
	}

	// Attempt to withdraw the given 'amount' of Ether from the account.
    function withdraw(address addr, uint amount) returns(uint new_value){
        // Skip if someone tries to withdraw 0 or if they don't have enough Ether to make the withdrawal.
        if (balances[msg.sender] < amount || amount == 0)
            return;
        balances[msg.sender] -= amount;
        msg.sender.send(amount);
        return balances[addr];
    }

    // Does a transfer using the recievers address to send inputted amount 
    function transfer(address receiver, uint amount) returns(bool sufficient) {
    	if (balances[msg.sender] < amount) return false;
    	balances[msg.sender] -= amount;
    	balances[receiver] += amount;

    	// Calls event transfer. 
    	Transfer(msg.sender, receiver, amount);
    	return true;
    }

    //remove contract from the block chain
    function remove() {
        if (msg.sender == owner){
            selfdestruct(owner);
        }
    }
}
