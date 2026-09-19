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

event raffleLogEntry(address indexed players);


    function enterRaffle() public payable {

 if(msg.value<i_entranceFee){
    revert Raffle_InsufficientFee();
 }

 raffleFunders.push(payable(msg.sender));

emit raffleLogEntry(msg.sender);

    }




    function pickWinner() public{




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