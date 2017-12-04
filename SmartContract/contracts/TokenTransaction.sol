pragma solidity ^0.4.18;

// The workaround plan for parity is that this database will only hold the mappings
// and nothing else. The functions will be public so that it can only be called at 
// TokenTransaction and nothing else.
contract TransactionFactory {

    //Structure/attributes for users, balances, and registration boolean. 
    struct UserAccount {
        address userAddress;
        bytes32 username; 
        uint256 enitBalance;
        bool registered;
    }

    address owner;

    //Mapping for accounts and names associated with them.
    mapping (bytes32 => UserAccount) public Accounts; 
    mapping (address => bytes32) public Names;

    int numberOfUsers = 0;

    // Logs the registration from the action.
    event Registered(bytes32 username, address userAddress);

    /* <constructor> TransactionFactory()
     * Purpose: Setting the owner 
     * Parameters: None.
     * Returns: Nothing
     */
    function TransactionFactory() public {
        owner = msg.sender;
    }

    /* <function> getBalance()
     * Purpose: returns the balance from an account
     * Parameters: byte32 username that we want the balance from.
     * Returns: the balance from that username's account.
     */
    function getBalance(bytes32 username) public constant returns(uint256) { 
        return (Accounts[username].enitBalance);
    }

    /* <function> getAddress()
     * Purpose: get the address from a given username
     * Parameters: username from an account
     * Returns: the address correlating to that username
     */
    function getAddress(bytes32 username) public constant returns(address) { 
        return (Accounts[username].userAddress) ; 
    }

    /* <function> getName()
     * Purpose: get the username from the address given
     * Parameters: an address
     * Returns: username correlated to that address. 
     */
    function getName(address uAddress) public constant returns(bytes32) { 
        return (Names[uAddress]) ; 
    }

    /* <function> register()
     * Purpose: creates a new account within the database
     * Parameters: unknownAddress, desiredName
     * Returns: bool
     */
    function register(address uAddress, bytes32 userName) public returns(bool success) {
        var account = Accounts[userName];
        Names[uAddress] = userName;
        account.userAddress = uAddress;
        account.username = userName;
        account.enitBalance = 0;
        account.registered = true;
        numberOfUsers++;
        Registered(userName, uAddress);
        return true; 
    }

    /* <function> isRegistered()
     * Purpose: checks if user is registered
     * Parameters: username 
     * Returns: bool
     */ 
    function isRegistered(bytes32 userName) public constant returns(bool registered) {
        if (Accounts[userName].registered) {
            return true; 
        } else {
            return false;
        }
    }
}

/* <contract> TokenTransaction
 * Purpose: Uses the mapping inheritted from TransactionFactory to transfer tokens.
 */
contract TokenTransaction is TransactionFactory {

    address public owner;
    
    // These events log the transfer/action to blockchain 
    event Sold(address buyer, address seller, uint256 enitAmount, uint256 etherAmount);
    event Bought(address buyer, address seller, uint256 enitAmount, uint256 etherAmount);
    event Transferred(address _from, address _to, uint256 value);
    event Deposit(address sender, uint256 buyer);
    event BadAction(address buyer, address otherBuyer, uint256 amountCost);
    uint256 ratioEtherToEnits = 3460;

    /* <function> TokenTransaction()
     * Purpose: creates the instance 
     * Parameters: None 
     * Returns: None
     */
    function TokenTransaction() TransactionFactory() public {
        owner = msg.sender;
    }

    /* <function> setBalance()
     * Purpose: Sets the balance of a user depending on username, amount and flag.
     * Parameters: bool flag:  true adds enit to the balance
     *                    false subtracts enit from the balance
     *        _username: uses the username for the account 
     *        amount: amount to be taken 
     * Returns: None
     */
    function setBalance(address _username, uint256 amount, bool flag) private {
        bytes32 username = getName(_username);
        if (flag) {
            Accounts[username].enitBalance += amount;
        } else { 
            Accounts[username].enitBalance -= amount;
        }
    }

    /* <function> convertToken()
     * Purpose: converts depending on boolean:
     *          False = Enits to Ethers 
     *          True = Ethers to Enits 
     * Parameters: boolean, uint256
     * Returns: None
     */
    function convertToken(bool toEnit, uint256 initialAmount) public constant returns(uint256 value){
        if (toEnit) {
            // Amount * 3460
            return (initialAmount * ratioEtherToEnits);
        } else {
            return (initialAmount / ratioEtherToEnits);
        }
    }

    /* <function> depositEnits()
     * Purpose: deposit money
     * Parameters: uint256
     * returns: bool
     */
    function depositEnits(bytes32 name, uint256 value) public {
        setBalance(getAddress(name), value, true);
        Deposit(getAddress(name), value);
    }

    /* Purpose: transfers ether to seller and enit to buyer
     * Parameters: string_seller, uint256_amount 
     * Returns: bool
     */
    // function transferEnergy(uint256 amount) payable public returns(bool) {
    //     (msg.sender).transfer(amount);
    //     return true; 
    // }

    /* Purpose: exchange money or a handshake here 
                buyer wants to buy energy from seller
     * Parameters: seller, buyer, amount 
     * Returns: bool
     */
    // function exchange(bytes32 _buyer, bytes32 _seller, uint amount) public returns(bool) {
    //     var seller = getAddress(_seller);
    //     var buyer = getAddress(_buyer);
    //     uint256 currentCost = convertToken(false, amount);  
    //     if (getBalance(_seller) < amount) { 
    //         return false ;
    //     }      
    //     if (buyer.balance < currentCost) { 
    //         return false ;
    //     }
    //     if (msg.sender != buyer) { 
    //         return false;
    //     }


    //     transferEnergy(currentCost, {from: buyer, to: seller}); 
    //     Brought(buyer, seller, amount, currentCost);
    //     Transferred(buyer, seller, currentCost);
    //     return true;
    // }

    /* <function> exchange1()
     * Purpose: This function is basically the handshake between the buyer and seller. 
     * Parameters: 
     *        _buyer: the address of the buyer
     *        _seller: the address of the seller
     *        _amount: the amount that is to be transfered.
     * Returns: bool 
     */
    function exchange1(bytes32 _buyer, bytes32 _seller, uint amount) private returns(bool) {
        var seller = getAddress(_seller);
        var buyer = getAddress(_buyer);
        uint256 currentCost = convertToken(false, amount);
        Sold(buyer, seller, amount, currentCost); //give me the event log of this event
        
        transferEnergy1(_buyer, _seller, amount); 
        Bought(buyer, seller, amount, currentCost);
        return true;
    }

    /* <function> transferEnergy1()
     * Purpose: This function does the actual transfer between the buyer and the seller
     * Parameters: 
     *        _buyer: the address of the buyer
     *        _seller: the address of the seller
     *        _amount: the amount that is to be transfered. 
     * Return: bool
     */
    function transferEnergy1(bytes32 buyer, bytes32 seller, uint256 amount) public returns(bool) {
        // Not enough enits to give out
        if ( getBalance(seller) < amount) { 
            return false;
        }
        
        // Sending and receiving the enits
        // Deleting seller's energy amount and increasing buyer's amount 
        setBalance(getAddress(seller), amount, false);
        depositEnits(buyer, amount);

        // Payable function - I want to send ethers to seller from buyers
        // GetAddress(seller).transfer(convertToken(false, amount));
        Transferred(getAddress(buyer), getAddress(seller), amount);
        return true; 
    }    
    
    /* <function> remove()
    * Purpose: Makes the contract remove itself from the blockchain.
    * Parameters: None.
    * Returns: Nothing
    */
    function remove() public {
        if (msg.sender == owner) {
            selfdestruct(owner);
        }
    }
}
