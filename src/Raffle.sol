// SPDX-License-Identifier:MIT

pragma solidity 0.8.19;


import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";





contract Raffle is VRFConsumerBaseV2Plus{

// CUSTOM ERRORS
error Raffle_InsufficientFee();
error NotEnoughTimePassed();


// variable declaration
uint256 private immutable i_entranceFee;
uint256 public s_lotteryStartTime;
uint256 private immutable i_intervalTime;
address payable[] public raffleFunders;


// Constructor
constructor(uint256 entranceFee,uint256 intervalTime,uint256 startTime){
i_entranceFee = entranceFee;
i_intervalTime = intervalTime;
s_lotteryStartTime = block.timestamp;
}

event raffleLogEntry(address indexed players);



    function enterRaffle() public payable {

 if(msg.value<i_entranceFee){
    revert Raffle_InsufficientFee();
 }

 raffleFunders.push(payable(msg.sender));

emit raffleLogEntry(msg.sender);

    }




    function pickWinner() public{
if((block.timestamp -s_lotteryStartTime)<i_intervalTime){
    revert NotEnoughTimePassed();
}



    }

    function checkEntranceFee() public view returns(uint256){
        return i_entranceFee;
    }

}

/*
git add .
git commit -m "Describe your changes here"
git push
 */