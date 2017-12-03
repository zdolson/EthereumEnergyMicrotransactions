pragma solidity ^0.4.18;
/* This is a database contract that will create TokenExchange contract 
 * it only contains the idenities of each address and their respective class
*/
contract TokenTransaction {

    address owner;
    bytes32 name;
    TransactionFactory database;
    // Log the transfer/action to blockchain 
    event Sold(address buyer, address seller, uint256 enitAmount, uint256 etherAmount);
    event Brought(address buyer, address seller, uint256 enitAmount, uint256 etherAmount);
    event Transferred(address _from, address _to, uint256 value);
    event Deposit(address sender, uint256 buyer);
    uint256 ratioEtherToEnits = 3460;

    /* Purpose: creates the instance 
     * Input: None 
     * Returns: None
     */
    function TokenTransaction(bytes32 username) public {
        owner = msg.sender;
        name = username;
        database = TransactionFactory(msg.sender); //factory will always be owner
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
    function depositEnits(uint256 value) public {
        database.setBalance(msg.sender, value, true);
        Deposit(msg.sender, value);
    }
    /* Purpose: transfers ether to seller and enit to buyer
     * Input: string_seller, uint256_amount 
     * Returns: bool
     */
    function transfer(bytes32 seller, uint256 amount) payable public returns(bool) {
        // not enough enits to give out
        if ( database.getBalance(seller) < amount) { 
            return false;
        }
        
        // sending and receiving the enits 
        database.setBalance(database.getAddress(seller), amount, false);
        depositEnits(amount);

        //payable function 
        database.getAddress(seller).transfer(convertToken(false, amount));
        Transferred(msg.sender, database.getAddress(seller), amount);
        return true; 
    }

    /* Purpose: exchange money or a handshake here 
                checks if owner has ethers to use
     * Input: seller, buyer, amount 
     * Returns: bool
     */
    function exchange(bytes32 _seller, uint amount) private returns(bool) {
        var seller = database.getAddress(_seller);

        uint256 currentCost = convertToken(false, amount);

        if ( msg.sender.balance < currentCost) {
            return false;
        }

        transfer(_seller, amount);
        Brought(msg.sender, seller, amount, currentCost);
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
    // address[] public contracts ; 
    mapping (bytes32 => address) public Contracts;
    // might create a permission mapping to give user some power like sudo
    int numberOfUsers = 0;

    event Registered(bytes32 username, address userAddress);
    event Action(address _transaction, address _creator);

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
        if (Accounts[userName].registered){
            return true; 
        } else {
            return false;
        }
    }
    /* Purpose: creates transaction contract and making the requestor its owner
     * Input: nothing 
     * returns: contract address 
     */ 
     // this might be wrong, but im assuming if someone else calls this 
     // it would be a different msg.sender from owner
     
     //// add an event of that address of the transaction
    function createTransaction(bytes32 name) public returns(bytes32) {
        address t = new TokenTransaction(name); 
        Contracts[name] = (t); // adding to contracts array the address
        Action(t, owner);
        return name; 
    }
     /* Purpose: ability to remove contract of an address 
      * Input: address of contract 
      * returns: bool
      */ 
    function removeTransaction(address transAddress) public {
        TokenTransaction(transAddress).remove();
    }

    function getContract(bytes32 name) public constant returns(address) {
        return Contracts[name] ;
    }
}