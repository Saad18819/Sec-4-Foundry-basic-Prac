// SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

contract Raffle{

// CUSTOM ERRORS

error Raffle_InsufficientFee();

uint256 public immutable i_entranceFee;


address payable[] public raffleFunders;

constructor(uint256 entranceFee){
i_entranceFee = entranceFee;
}


    function enterRaffle() public payable {

 if(msg.value<i_entranceFee){
    revert Raffle_InsufficientFee();
 }

 raffleFunders.push(payable(msg.sender));


    }




    function pickWinner() public{



    }

}