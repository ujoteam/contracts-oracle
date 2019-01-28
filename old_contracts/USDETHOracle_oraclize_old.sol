pragma solidity ^0.4.23;
import "./utils/usingOraclize.sol";


contract USDETHOracle is usingOraclize {

    string public ethUsdString;

    address public admin;
    bool public lock = false;
    uint256 public intervalInSeconds;
    bytes32 public pendingId = 0;
    string public url;

    event LogOraclizeQuery(string description);
    event LogNewPrice(string price);

    function USDETHOracle(address _admin, uint256 _interval) public {
        admin = _admin;
        intervalInSeconds = _interval;
        oraclize_setCustomGasPrice(10000000000); // 10 gwei default
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
        require(pendingId == myid);

        ethUsdString = result;
        emit LogNewPrice(ethUsdString);

        require(!lock);
        emit LogOraclizeQuery("Oraclize Queried");
        pendingId = oraclize_query(intervalInSeconds, "URL", url, 150000);
    }

    function update() public payable onlyAdmin {
        require(!lock);
        emit LogOraclizeQuery("Oraclize Queried");
        pendingId = oraclize_query("URL", url, 150000);
    }

    function setGasPrice(uint256 _newGasPrice) public onlyAdmin {
        oraclize_setCustomGasPrice(_newGasPrice); // 10 gwei default
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
        return parseInt(ethUsdString);
    }
}
