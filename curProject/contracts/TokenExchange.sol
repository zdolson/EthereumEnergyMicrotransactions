pragma solidity ^0.4.18;

contract TokenExchange {

		address owner;

		// Logs the transfer to blockchain
		event Sold(address indexed buyer, address indexed seller,
							uint256 enitAmount, uint256 etherAmount);
		event Bought(address indexed seller, address indexed buyer,
			 				uint256 enitAmount, uint256 etherAmount);
		event Registered(string username, address indexed userAddress);
		event Transfered(address indexed _from, address indexed _to, uint256 _value);

		struct UserAccount {
				address userAddress;
				string username;
				uint256 enitBalance;
				bool registered;
		}

		// Maintain number of UserAccounts registered.
		uint256 numberOfUsers;

		// Create the "dict" Accounts with mapping,
		// holds all UserAccounts currently registered.
		mapping (string => UserAccount) public Accounts;
		mapping (address => string) private AccountLabels;
		/* USD $1 is roughly 0.002408883964 Ether.
		 * Average cost of a kWh is $0.12 in the US.
		 * USD $0.12 = 0.0002890660757 Ether.
		 * Thus - one energy unit (Enit) = 0.0002890660757 Ether;
		 * 				one Ether = 3,459.4166665127 Enits
		 */
		uint256 ratioEtherToEnits = 3460;

		/* <constructor> TokenExchange()
		 * Purpose: Creates the TokenExchange Contract Object.
		 * Parameters: None.
		 * Returns: Nothing.
		 * NOTE: UNSURE THAT THIS IS ACTUALLY BEING RUN.
		 */
		function TokenExchange() internal {
				owner = msg.sender;
				/* USD $1 is roughly 0.002408883964 Ether.
				 * Average cost of a kWh is $0.12 in the US.
				 * USD $0.12 = 0.0002890660757 Ether.
				 * Thus - one energy unit (Enit) = 0.0002890660757 Ether;
				 * 				one Ether = 3,459.4166665127 Enits
				 */
				// uint256 ratioEtherToEnits = 3460;
		}

		/* <function> convertToken()
		* Purpose: Converts depending on boolean: true converts initialAmount
		*			 		from Ether to Enits, false converts from Enits to Ether.
		* Parameters: boolean, uint256
			* Returns: Nothing.
		*/
		function convertToken(bool toEnit, uint256 initialAmount) private constant returns(uint256) {
				// True: Convert Ether to Enit.
				if (toEnit){
						// Amount of Ether * 3460
						return initialAmount * ratioEtherToEnits;
				} else { // False: Convert Enit to Ether.
						return initialAmount / ratioEtherToEnits;
				}
		}

		/* <function> getEnitBalance()
		 * Purpose: Returns given username's enitBalance.
		 * Parameters: string
		 * Returns: uint256
		 */
		function getEnitBalance(string userName) public constant returns (uint256) {
				var account = Accounts[userName];
				return account.enitBalance;
		}

		/* <function> depositEnits()
		 * Purpose: Desposits Enits into the given username's enitBalance.
		 * Parameters: string, uint256
		 * Returns: uint256
		 */
		function depositEnits(string userName, uint256 value)
													public returns(uint) {
				var account = Accounts[userName];
				account.enitBalance += value;
				return account.enitBalance;
		}

    	/* <function> transfer()
		 * Purpose: Transfers Ether to Seller and Enits to Buyer;
		 *					Buyer is gaining Enits and losing Ether,
		 * 			 		Seller is losing Enits and gaining Ether.
		 * Parameters: UserAccount, uint256
		 * Returns: boolean
		 */
    	function transfer(string _seller, uint256 amount) public payable returns(bool) {
				// UPDATED: uses UserAccount instead of sender
				var seller = Accounts[_seller];
				if (seller.enitBalance < amount) {
					return false;
				}
				seller.enitBalance -= amount;

				// NEEDS REWORKING
				Accounts[AccountLabels[msg.sender]].enitBalance += amount;
				(seller.userAddress).transfer(convertToken(false, amount));
				// Calls event transfer.
				Transfered(msg.sender, seller.userAddress, amount);
				return true;
    	}

		/* <function> exchange()
		* Purpose: Exchanging Enits and Ether; checks to see if sufficient ether
		* 					from Buyer, and sufficient Enits from Seller and
		*					then calls transfer(), else returns false.
		* Parameters: string, string, uint
		* Returns: boolean
		*/
		function exchange(string sellerName, string buyerName, uint amount)
											public returns (bool) {
				var seller = Accounts[sellerName];
				var buyer = Accounts[buyerName];

				// Buyer requests amount (kWh), convert that value to be in Ether
      			uint256 currentCost = convertToken(false, amount);

				// NEEDS REWORKING TO HANDLE NEW ACCOUNT STRUCT
      			// msg.balance - gets the ether balnceof the msg
      			if ((seller.userAddress).balance < currentCost) {
              		return false ;
          		}
				// UPDATED: to use UserAccount instead of sender
      			transfer(sellerName, amount);

				Sold(buyer.userAddress, seller.userAddress, amount, currentCost);
      			return true ;
    	}

		/* <function> register()
		 * Purpose: Creates a new account inside of the contract, adds to mapping.
		 * Parameters: address, string
		 * Returns: boolean
		 */
		function register(address uAddress, string userName) public returns(bool) {
				var account = Accounts[userName];
				AccountLabels[uAddress] = userName;
				account.userAddress = uAddress;
				account.username = userName;
				account.enitBalance = 0;
				account.registered = true;
				numberOfUsers++;
				return true;
		}

		/* <function> isRegistered()
		 * Purpose: Checks whether or not a certain username is registered.
		 * Parameters: string
		 * Returns: boolean.
		 */
		function isRegistered(string userName) public constant returns(bool) {
				if (Accounts[userName].registered) {
					return true;
				} else {
					return false;
				}
		}

		/* <function> remove()
		 * Purpose: Makes the contract remove itself from the blockchain.
		 * Parameters: None.
		 * Returns: Nothing
		 */
    function remove() public {
        if (msg.sender == owner){
            selfdestruct(owner);
        }
    }
}
