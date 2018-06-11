pragma solidity ^0.4.23;
import "./utils/usingOraclize.sol";


contract USDETHOracle is usingOraclize {

    string public ethUsdString;
    uint public ethUsdUint;
    uint public lastUpdated;

    address public admin;
    bool public lock = false;
    uint256 public intervalInSeconds;
    mapping(bytes32 => bool) public myidList;
    string public url;

    event LogOraclizeQuery(string description);
    event LogNewPrice(string price);
    event LogCalled(string desc);

    function USDETHOracle(address _admin, uint256 _interval) public {
        admin = _admin;
        intervalInSeconds = _interval;
        // default on deploy
        url = "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0";
    }

    modifier onlyAdmin {
        require(msg.sender == admin);
        _;
    }

    // anyone should be able to fund the oracle if necessary
    function () public payable {} // solhint-disable-line no-empty-blocks

    function __callback(bytes32 myid, string result) public { // solhint-disable-line
        require(msg.sender == oraclize_cbAddress());
        require(myidList[myid] != true);
        myidList[myid] = true; // mark this myid (default bool value is false)

        emit LogCalled("Received callback");
        ethUsdString = result;
        ethUsdUint = parseInt(result);
        lastUpdated = now; // solhint-disable-line not-rely-on-time
        emit LogNewPrice(ethUsdString);

        if (!lock) {
            emit LogOraclizeQuery("Oraclize query was sent, standing by for the answer..");
            oraclize_query(
            intervalInSeconds,
            "URL",
            url
            );
        }
    }

    function update() public payable onlyAdmin {
        require(!lock);
        if (oraclize_getPrice("URL") > this.balance) {
            emit LogOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            emit LogOraclizeQuery("Oraclize query was sent, standing by for the answer..");
            oraclize_query("URL", url);
        }
    }

    function updateInterval(uint256 _newInterval) public onlyAdmin {
        intervalInSeconds = _newInterval;
    }

    function lockOracle() public onlyAdmin {
        lock = !lock;
    }

    function changeURL(string _newURL) public onlyAdmin {
        url = _newURL;
    }

    function changeAdmin(address _newAdmin) public onlyAdmin {
        admin = _newAdmin;
    }

    function drainOracle() public onlyAdmin {
        msg.sender.transfer(this.balance);
    }

    function getPrice() public constant returns (string) {
        return ethUsdString;
    }

    function getUintPrice() public constant returns (uint) {
        return ethUsdUint;
    }
}
