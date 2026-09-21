// SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract Raffle is VRFConsumerBaseV2Plus {
    // CUSTOM ERRORS
    error Raffle_InsufficientFee();
    error NotEnoughTimePassed();
    error Raffle_raffleEntryClosed();
    error Raffle_transferFailed();


// TYPE DECLARATION
enum raffleState{

Open,
Calculating

}

    // variable declaration
    uint256 private immutable i_entranceFee;
    uint256 public s_lotteryStartTime;
    uint256 private immutable i_intervalTime;
    address payable[] public raffleFunders;
    uint256 private s_raffleState;
    address public s_recentwinner;


    // client struct variable declaration
    bytes32 private immutable i_keyHash;
    uint256 private immutable i_subId;
    uint16 private constant REQUEST_CONFIRMATION = 3;
    uint32 private immutable i_callbackGasLimit;
    uint32 private constant NUM_WORDS = 1;


    // Constructor
    constructor(uint256 entranceFee, uint256 intervalTime, uint256 startTime, bytes32 gaslane, uint256 subId, uint32 callbackGasLimit, address VRFCOORDINATOR)
    VRFConsumerBaseV2Plus(VRFCOORDINATOR)
     {
        i_entranceFee = entranceFee;
        i_intervalTime = intervalTime;
        s_lotteryStartTime = block.timestamp;
        i_keyHash = gaslane;
i_subId = subId;
i_callbackGasLimit = callbackGasLimit;
s_raffleState = raffleState.Open;
    }


// EVENTS
    event raffleLogEntry(address indexed players);
    event raffleWinner(address indexed winner);


// FUNCTIONS
    function enterRaffle() public payable {
       
        if (msg.value < i_entranceFee) {
            revert Raffle_InsufficientFee();
        }

        if(s_raffleState != raffleState.Open){
            revert Raffle_raffleEntryClosed();
        }

        raffleFunders.push(payable(msg.sender));

        emit raffleLogEntry(msg.sender);
    }

/**
 * @dev this is the function that the chainlink nodes will call to see
 * if the lottery is ready to have winner picked
 * The following should be true in order for upKeepNeeded to be true:
 * 1.The time interval 
 */

function checkUpkeep (bytes calldata /*checkData */) public view returns(bool upKeepNeeded, bytes memory /*performData*/) {




}






    function pickWinner() public {
        if ((block.timestamp - s_lotteryStartTime) < i_intervalTime) {
            revert NotEnoughTimePassed();
        }


      s_raffleState != raffleState.Calculating;




        VRFV2PlusClient.RandomWordsRequest memory request = VRFV2PlusClient.RandomWordsRequest({
             keyHash:i_keyHash,
   subId :i_subId,
     requestConfirmations : REQUEST_CONFIRMATION,
     callbackGasLimit :i_callbackGasLimit,
    numWords :NUM_WORDS,
    extraArgs: VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({nativePayment: true}))
        });
        uint256 requestId = s_vrfCoordinator.requestRandomWords(request);

    }



 function fulfillRandomWords(uint256 requestId, uint256[] calldata randomWords) internal override{


// EFFECTS
uint256 private winnerIndex = randomWords[0] % raffleFunders.length;
 address payable winnerAdd = raffleFunders[winnerIndex];
s_winner = winnerAdd;
raffleFunders = new address payable[](0);
s_raffleState = raffleState.Open;
s_lotteryStartTime = block.timestamp();
emit raffleWinner(s_winner);


// INTERACTIONS
(bool success,)=s_winner.call{value:address(this).balance}("");

if(!success){
    revert Raffle_transferFailed();
}






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