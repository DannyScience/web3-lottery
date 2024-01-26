pragma solidity 0.8.24;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract Lottery {

    address payable[] public players;
    uint256 public usdEntryFee;
    AggregatorV3Interface public ethUsdPriceFeed;

    constructor(address _priceFeedAddress) {
        usdEntryFee = 50 * 10 ** 18;
        ethUsdPriceFeed = AggregatorV3Interface(_priceFeedAddress); 

    }

    function enter() public payable {}
    function getEntranceFee() public view returns (uint256) {}

}
