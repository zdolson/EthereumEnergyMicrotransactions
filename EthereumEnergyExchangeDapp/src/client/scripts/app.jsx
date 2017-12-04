import React from 'react';
import {bonds, formatBlockNumber, formatBalance, isNullData} from 'oo7-parity';
import {Bond, TimeBond} from 'oo7';
import {Rspan} from 'oo7-react';
import {InputBond, HashBond, BButton, TransactButton, TransactionProgressLabel} from 'parity-reactive-ui';


/* Constant Variable: EEEabi
 * Purpose: Used when creating a contract bonds object.
 */
const EEEabi =
[
		{
				"constant":true,"inputs":[
						{
								"name":"",
								"type":"address"
						}
				],
				"name":"Names",
				"outputs":[
						{
								"name":"",
								"type":"bytes32"
						}
				],
				"payable":false,
				"stateMutability":"view",
				"type":"function"
		},
		{
				"constant":false,
				"inputs":[
						{
								"name":"uAddress",
								"type":"address"
						},
						{
								"name":"userName",
								"type":"bytes32"
						}
				],
				"name":"register",
				"outputs":[
						{
								"name":"success",
								"type":"bool"
						}
				],
				"payable":false,
				"stateMutability":"nonpayable",
				"type":"function"
		},
		{
				"constant":true,
				"inputs":[
						{
								"name":"username",
								"type":"bytes32"
						}
				],
				"name":"getAddress",
				"outputs":[
						{
								"name":"",
								"type":"address"
						}
				],
				"payable":false,
				"stateMutability":"view",
				"type":"function"
		},
		{
				"constant":true,
				"inputs":[
						{
								"name":"userName",
								"type":"bytes32"
						}
				],
				"name":"isRegistered",
				"outputs":[
						{
							"name":"registered",
							"type":"bool"
						}
				],
				"payable":false,
				"stateMutability":"view",
				"type":"function"
		},
		{
				"constant":true,
				"inputs":[
						{
								"name":"toEnit",
								"type":"bool"
						},
						{
								"name":"initialAmount",
								"type":"uint256"
						}
				],
				"name":"convertToken",
				"outputs":[
						{
								"name":"value",
								"type":"uint256"
						}
				],
				"payable":false,
				"stateMutability":"view",
				"type":"function"
		},
		{
				"constant":true,
				"inputs":[
						{
								"name":"uAddress",
								"type":"address"
						}
				],
				"name":"getName",
				"outputs":[
						{
								"name":"",
								"type":"bytes32"
						}
				],
				"payable":false,
				"stateMutability":"view",
				"type":"function"
		},
		{
				"constant":true,
				"inputs":[],
				"name":"owner",
				"outputs":[
						{
								"name":"",
								"type":"address"
						}
				],
				"payable":false,
				"stateMutability":"view",
				"type":"function"
		},
		{
				"constant":false,
				"inputs":[
						{
								"name":"buyer",
								"type":"bytes32"
						},
						{
								"name":"seller",
								"type":"bytes32"
						},
						{
								"name":"amount",
								"type":"uint256"
						}
				],
				"name":"transferEnergy1",
				"outputs":[
						{
								"name":"",
								"type":"bool"
						}
				],
				"payable":false,
				"stateMutability":"nonpayable",
				"type":"function"
		},
		{
				"constant":true,
				"inputs":[
						{
								"name":"username",
								"type":"bytes32"
						}
				],
				"name":"getBalance",
				"outputs":[
						{
								"name":"",
								"type":"uint256"
						}
				],
				"payable":false,
				"stateMutability":"view",
				"type":"function"
		},
		{
				"constant":true,
				"inputs":[
						{
								"name":"",
								"type":"bytes32"
						}
				],
				"name":"Accounts",
				"outputs":[
						{
								"name":"userAddress",
								"type":"address"
						},
						{
								"name":"username",
								"type":"bytes32"
						},
						{
								"name":"enitBalance",
								"type":"uint256"
						},
						{
								"name":"registered",
								"type":"bool"
						}
				],
				"payable":false,
				"stateMutability":"view",
				"type":"function"
		},
		{
				"constant":false,
				"inputs":[],
				"name":"remove",
				"outputs":[],
				"payable":false,
				"stateMutability":"nonpayable",
				"type":"function"
		},
		{
				"constant":false,
				"inputs":[
						{
								"name":"name",
								"type":"bytes32"
						},
						{
								"name":"value",
								"type":"uint256"
						}
				],
				"name":"depositEnits",
				"outputs":[],
				"payable":false,
				"stateMutability":"nonpayable",
				"type":"function"
		},
		{
				"inputs":[],
				"payable":false,
				"stateMutability":"nonpayable",
				"type":"constructor"
		},
		{
				"anonymous":false,
				"inputs":[
						{
								"indexed":false,
								"name":"buyer",
								"type":"address"
						},
						{
								"indexed":false,
								"name":"seller",
								"type":"address"
						},
						{
								"indexed":false,
								"name":"enitAmount",
								"type":"uint256"
						},
						{
								"indexed":false,
								"name":"etherAmount",
								"type":"uint256"
						}
				],
				"name":"Sold","type":"event"
		},
		{
				"anonymous":false,
				"inputs":[
						{
								"indexed":false,
								"name":"buyer",
								"type":"address"
						},
						{
								"indexed":false,
								"name":"seller",
								"type":"address"
						},
						{
								"indexed":false,
								"name":"enitAmount",
								"type":"uint256"
						},
						{
								"indexed":false,
								"name":"etherAmount",
								"type":"uint256"
						}
				],
				"name":"Bought",
				"type":"event"
		},
		{
				"anonymous":false,
				"inputs":[
						{
								"indexed":false,
								"name":"_from",
								"type":"address"
						},
						{
								"indexed":false,
								"name":"_to",
								"type":"address"
						},
						{
								"indexed":false,
								"name":"value",
								"type":"uint256"
						}
				],
				"name":"Transferred",
				"type":"event"
		},
		{
				"anonymous":false,
				"inputs":[
						{
								"indexed":false,
								"name":"sender",
								"type":"address"
						},
						{
								"indexed":false,
								"name":"buyer",
								"type":"uint256"
						}
				],
				"name":"Deposit",
				"type":"event"
		},
		{
				"anonymous":false,
				"inputs":[
						{
								"indexed":false,
								"name":"buyer",
								"type":"address"
						},
						{
								"indexed":false,
								"name":"otherBuyer",
								"type":"address"
						},
						{
								"indexed":false,
								"name":"amountCost",
								"type":"uint256"
						}
				],
				"name":"BadAction",
				"type":"event"
		},
		{
				"anonymous":false,
				"inputs":[
						{
								"indexed":false,
								"name":"username",
								"type":"bytes32"
						},
						{
								"indexed":false,
								"name":"userAddress",
								"type":"address"
						}
				],
				"name":"Registered",
				"type":"event"
		}
]

/* Constant Variable: EEEAddress
 * Purpose: Used when creating a contract bonds object.
 */
const EEEAddress = '0xe7A3a606dc94067Aa811487bBbD96a45411A07e5';

export class App extends React.Component {

		constructor() {
				super();
				/* Bonds Variable: eeeContract
				 * Purpose: Create the Ethereum Energy Exchange contract bonds object.
				 * Parameters: Contract Address (hex string), Contract ABI
				 */
				this.eeeContract = bonds.makeContract(EEEAddress, EEEabi);

				/* Bonds Variables
				 * Purpose: Used for checking and working with multiple values.
				 */
				this.senderAddress = new Bond;
				this.recipientName = new Bond;
				this.energyAmount = new Bond;
				this.currentUser = this.eeeContract.getName(bonds.me);
				this.currentUserAddress = this.eeeContract.getAddress(this.currentUser);
				this.currentUserEnitBalance = this.eeeContract.getBalance(this.currentUser);
				this.recipientAddress = this.eeeContract.getAddress(this.recipientName);
				this.registered = this.eeeContract.isRegistered(this.recipientName);

				// Currently doesn't work, issues with running convertToken
				// inside of Dapp.
				//this.enitInEther = this.eeeContract.convertToken(false, this.energyAmount);

		}

		render() {
				var newUsername = new Bond;
				var newAddress = new Bond;
				var faucetAmount = new Bond;

				return (
						<body style={{backgroundColor:"#cceeff"}}>
								<hr />

								<div style={{float:"left", marginLeft:"5%"}}>
										<h2>Current account signed in: </h2>

										<div>
												<Rspan>
														Username:&nbsp;
														{this.currentUser}
														<br />
														Address:&nbsp;
														{this.currentUserAddress}
														<br />
												</Rspan>
										</div>

										<br />
										<hr />
										<br />

										<div>
												<h3>Need Enits to Trade?</h3>
												<Rspan>
														<InputBond bond={faucetAmount} placeholder='Amount in Enits' />
												</Rspan>
												<BButton
														content={'Drink from the Enit Faucet of Life.'}
														disabled={faucetAmount.map(isNullData)}
														onClick={() => this.eeeContract.depositEnits(this.currentUser, faucetAmount)}
														style={{backgroundColor:"#ffa500", marginLeft:"0.5em"}}
												/>
										</div>

										<br />
										<hr />
										<br />

										<div>
												<h3>Energy Exchange?</h3>
												Who would you like to transfer <Rspan>{this.energyAmount}</Rspan>(kWh) to?

												<InputBond style={{marginLeft:"0.5em"}} bond={this.recipientName} placeholder='Name of Recipient' />

												<br />
												<br />

												How much energy (kWh) would you like to sell?

												<Rspan>
														<InputBond style={{marginLeft:"0.5em"}} bond={this.energyAmount} placeholder='Amount in kWH' />
												</Rspan>

												<br />
												<br />

												<BButton
														content={this.recipientName.map(n => `Sell energy to ${n}.`)}
														disabled={false}
														onClick={() => this.eeeContract.exchange1(this.recipientName, this.currentUser, this.energyAmount)}
														style={{backgroundColor:"#ffa500"}}
												/>
										</div>

								</div>

								<div style={{float:"right", marginRight:"5%"}}>
										New User? Register Here!
										<hr />
										<br />

										<Rspan>
												<InputBond bond={newUsername} placeholder='New Username' />
												<br />
												<br />
												<InputBond bond={newAddress} placeholder='Account Address' />
										</Rspan>

										<br />
										<br />

										<BButton
												content={'Register Account'}
												disabled={newAddress.map(isNullData)}
												onClick={() => this.eeeContract.register(newAddress, newUsername)}
												style={{backgroundColor:"#ffa500"}}
										/>
										<br />
								</div>
								
						</body>
				);
		}
}
