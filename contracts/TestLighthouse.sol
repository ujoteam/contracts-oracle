pragma solidity ^0.4.23;
import "./ILighthouse.sol";

//Simplified Interface for Rhombus Lighthouse Oracle
contract TestLighthouse {
    
    function peekData() external view returns (uint128 v,bool b) {
        return (121, true);
    }
}
