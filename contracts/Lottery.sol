pragma solidity 0.8.24;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

contract Lottery is Ownable {

    address payable[] public players;
    uint256 public usdEntryFee;
    AggregatorV3Interface internal ethUsdPriceFeed;
    enum LOTTERY_STATE{
        OPEN,
        CLOSED,
        CALCULATING_WINNER
    }
    LOTTERY_STATE public lottery_state;


    constructor(address _priceFeedAddress) {
        usdEntryFee = 50 * 10 ** 18;
        ethUsdPriceFeed = AggregatorV3Interface(_priceFeedAddress);
        lottery_state = LOTTERY_STATE.CLOSED;

    }

    function enter() public payable {
        require(lottery_state == LOTTERY_STATE.OPEN, "Lottery is not active");
        require(msg.value >= calculateEntranceFee(), "Not enough ETH");
        players.push(payable(msg.sender));
    }

    function calculateEntranceFee() public view returns (uint256) {
        ( , uint price, , , ) = ethUsdPriceFeed.latestRoundData();
        uint256 ethEntryFee = (usdEntryFee / (price * 10 ** 10)) * 10 ** 18;
    return ethEntryFee;
    }

    function startLottery() public onlyOwner {
        require(lottery_state == LOTTERY_STATE.CLOSED);
        lottery_state = LOTTERY_STATE.OPEN;
    }

    function endLottery() public onlyOwner {
        require(lottery_state == LOTTERY_STATE.OPEN);
        lottery_state = LOTTERY_STATE.CALCULATING_WINNER;

    }
}
