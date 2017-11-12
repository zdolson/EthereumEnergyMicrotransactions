pragma solidity ^0.4.4;

contract TestBank {

	address owner;

	// Somewhat like a hashtable of addresses/balances
	mapping (address => uint) balances;

	function TestBank(){
		owner = msg.sender;

		//tx.origin -> getting original caller's information. Owner can NOT be a contract
		//msg.sender -> owner can be a contract
		balances[msg.sender] = 1000;
	}

	// Returns current balance in a specific account
	function getBalance(address addr) returns(uint){
		return balances[addr];
	}

	function deposit(uint value) returns(uint new_value) {
		balances[msg.sender] += msg.value;
	}

	// Attempt to withdraw the given 'amount' of Ether from the account.
    function withdraw(uint amount) {
        // Skip if someone tries to withdraw 0 or if they don't have enough Ether to make the withdrawal.
        if (balances[msg.sender] < amount || amount == 0)
            return;
        balances[msg.sender] -= amount;
        msg.sender.send(amount);
    }

    //remove contract from the block chain
    function remove() {
        if (msg.sender == owner){
            selfdestruct(owner);
        }
    }
}
