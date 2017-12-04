pragma solidity ^0.4.18;

/* Alright, 4th change in the entire program, this time the database will only have the mappings 
 * and the ability to register users onto the database, however, it will not create new contracts
 */

// the workaround plan for parity is that this database will only hold the mappings
// and nothing else. The functions will be public so that it can only be called at 
// TokenTransaction and nothing else.
contract TransactionFactory {

    struct UserAccount {
        address userAddress;
        bytes32 username; 
        uint256 enitBalance;
        bool registered;
    }

    address owner;
    mapping (bytes32 => UserAccount) public Accounts; 
    mapping (address => bytes32) public Names; //kind of inefficient but it is what it is
    // might create a permission mapping to give user some power like sudo
    int numberOfUsers = 0;

    event Registered(bytes32 username, address userAddress);

    /* Purpose: Setting the owner 
     * Returns: Nothing, just set who is the boss
    */
    function TransactionFactory() public {
        owner = msg.sender;
    }

    function getBalance(bytes32 username) public constant returns(uint256) { 
        return (Accounts[username].enitBalance);
    }
    function setBalance(address _username, uint256 amount, bool flag) public {
        bytes32 username = getName(_username);
        if (flag) {
            Accounts[username].enitBalance += amount;
        } else { 
            Accounts[username].enitBalance -= amount;
        }
    }
    function getAddress(bytes32 username) public constant returns(address) { 
        return (Accounts[username].userAddress) ; 
    }
    function getName(address uAddress) public constant returns(bytes32) { 
        return (Names[uAddress]) ; 
    }
    /* Purpose: creates a new account within the database
     * Input: unknownAddress, desiredName
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
    /* Purpose: checks if user is registered
     * Input: username 
     * returns: bool
     */ 
    function isRegistered(bytes32 userName) public constant returns(bool registered) {
        if (Accounts[userName].registered) {
            return true; 
        } else {
            return false;
        }
    }
}

contract TokenTransaction is TransactionFactory {

    address public owner;
    // Log the transfer/action to blockchain 
    event Sold(address buyer, address seller, uint256 enitAmount, uint256 etherAmount);
    event Brought(address buyer, address seller, uint256 enitAmount, uint256 etherAmount);
    event Transferred(address _from, address _to, uint256 value);
    event Deposit(address sender, uint256 buyer);
    event BadAction(address buyer, address otherBuyer, uint256 amountCost);
    uint256 ratioEtherToEnits = 3460;

    /* Purpose: creates the instance 
     * Input: None 
     * Returns: None
     */
    function TokenTransaction() TransactionFactory() public {
        owner = msg.sender;
    }

    /* Purpose: converts depending on boolean:
                False = Enits to Ethers 
                True = Ethers to Enits 
     * Input: boolean, uint256
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
    /* Purpose: deposit money
     * Input: uint256
     * returns: bool
     */
    // might have an error here 
    function depositEnits(bytes32 name, uint256 value) public {
        setBalance(getAddress(name), value, true);
        Deposit(getAddress(name), value);
    }
    /* Purpose: transfers ether to seller and enit to buyer
     * Input: string_seller, uint256_amount 
     * Returns: bool
     */
    function transferEnergy(uint256 amount) payable public returns(bool) {
        (msg.sender).transfer(amount);
        return true; 
    }

    /* Purpose: exchange money or a handshake here 
                buyer wants to buy energy from seller
     * Input: seller, buyer, amount 
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

    function exchange1(bytes32 _buyer, bytes32 _seller, uint amount) public returns(bool) {
        var seller = getAddress(_seller);
        var buyer = getAddress(_buyer);
        uint256 currentCost = convertToken(false, amount);
        Sold(buyer, seller, amount, currentCost); //give me the event log of this event
        
        transferEnergy1(_buyer, _seller, amount); 
        Brought(buyer, seller, amount, currentCost);
        return true;
    }
    function transferEnergy1(bytes32 buyer, bytes32 seller, uint256 amount) public returns(bool) {
        // not enough enits to give out
        if ( getBalance(seller) < amount) { 
            return false;
        }
        
        // sending and receiving the enits
        // deleting seller's energy amount and increasing buyer's amount 
        setBalance(getAddress(seller), amount, false);
        depositEnits(buyer, amount);

        //payable function - I want to send ethers to seller from buyers
        // getAddress(seller).transfer(convertToken(false, amount));
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
