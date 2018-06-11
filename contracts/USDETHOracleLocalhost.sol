/*
For testing using the Ethereum Bridge on localhost.
Requires setting to your own resolver.
*/

pragma solidity ^0.4.23;
import "./USDETHOracle.sol";


contract USDETHOracleLocalhost is USDETHOracle {

    function USDETHOracleLocalhost(address _admin, uint256 _interval) public USDETHOracle(_admin, _interval) {
        //replace with new address when run again
        OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
    }

}
