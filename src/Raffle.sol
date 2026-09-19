// SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract Raffle is VRFConsumerBaseV2Plus {
    // CUSTOM ERRORS
    error Raffle_InsufficientFee();
    error NotEnoughTimePassed();

    // variable declaration
    uint256 private immutable i_entranceFee;
    uint256 public s_lotteryStartTime;
    uint256 private immutable i_intervalTime;
    address payable[] public raffleFunders;

    // client struct variable declaration
    bytes32 private immutable i_keyHash;
    uint256 private immutable i_subId;
    uint16 private constant REQUEST_CONFIRMATION = 3;
    uint32 private immutable i_callbackGasLimit;
    uint32 private constant NUM_WORDS = 1;

    // Constructor
    constructor(uint256 entranceFee, uint256 intervalTime, uint256 startTime,bytes32 gaslane,uint256 subId,uint32 callbackGasLimit,address VRFCOORDINATOR)
    VRFConsumerBaseV2Plus(VRFCOORDINATOR)
     {
        i_entranceFee = entranceFee;
        i_intervalTime = intervalTime;
        s_lotteryStartTime = block.timestamp;
        i_keyHash = gaslane;
i_subId = subId;
i_callbackGasLimit = callbackGasLimit;

    }

    event raffleLogEntry(address indexed players);

    function enterRaffle() public payable {
        if (msg.value < i_entranceFee) {
            revert Raffle_InsufficientFee();
        }

        raffleFunders.push(payable(msg.sender));

        emit raffleLogEntry(msg.sender);
    }

    function pickWinner() public {
        if ((block.timestamp - s_lotteryStartTime) < i_intervalTime) {
            revert NotEnoughTimePassed();
        }

        VRFV2PlusClient.RandomWordsRequest memory request = VRFV2PlusClient.RandomWordsRequest({});

    }

    function checkEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }
}

/*
git add .
git commit -m "Describe your changes here"
git push
 */