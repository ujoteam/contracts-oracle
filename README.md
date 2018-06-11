# Ujo Oracles using Oraclize

[![CircleCI](https://circleci.com/gh/UjoTeam/contracts-oracle.svg?style=svg)](https://circleci.com/gh/UjoTeam/contracts-oracle)

The oracle works by using Oraclize. With oraclize you specify a remote URL in the smart contract itself. With this, calling this function, it will take some ether in the oracle and pay towards Oraclize. Oraclize will then in an async fashion return to the callback function the result.

In this case it's the USD exchange rate from Kraken.

Thus, in order to update the price, one needs to issue a tx first to the oracle, upon which it will receive a transaction from Oraclize into the oracle contract.

The oracle will automatically continue to issue a new query to oraclize according to an interval.

This interval can be changed by an administrator. Each update() call will initiate a thread essentially. It is thus possible to call it multiple times (by the admin) and bankrupt the oracle. In order to stop the loops, an admin can lock it temporarily.

To kickstart it, one needs to be an admin.

Step 1: Call oracle.update()  
Step 1.5: After confirming above, oracle will send its own tx.  

I have put the bare-bones of this into a gist, that one can load straight Remix. http://remix.ethereum.org/#version=soljson-v0.4.13+commit.fb4cb1a.js&gist=e1cad579bf90992ecfc248c1b24f38f2. This will load the necessary contracts.  

In Remix, one then needs to make sure that Metamask is injecting properly (for the right network as well). Then take the address (from the appropriate build files), and use the "At Address" function in Remix.  

After this, you can then do the above steps. Follow along in Rinkeby.

# Testing

To test locally, do the following:

1. "npm install"
2. run "node ./node_modules/ganache-cli/build/cli.node.js --mnemonic "ujo music service" --accounts 5" in its own tab.
3. run "node ./node_modules/ethereum-bridge/bridge -H localhost:8545 -a 2" in its own tab.
4. follow the instructions and copy the relevant line of code into the USDETHOracle_localhost contract [the default should be the same, so this might not be necessary].
5. "npm run test" [runs linter & does truffle test --network ganachecli]

It sets the calls 20 seconds apart. In some circumstances the tests might fail due to prices staying the same.

# CI

CircleCI mimics the above steps to run tests, except it adds coverage reporting.

# Coverage

Coverage plans to be added, but it is currently hanging infrequently on instrumentation. Opened up an issue.
