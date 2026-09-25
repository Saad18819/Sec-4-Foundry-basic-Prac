// SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

import {Test} from "forge-std/Test.sol";
import {Raffle} from "../src/Raffle.sol";
import { Deploycontract} from "../script/DeployScript.s.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract RaffleTest is Test{
Raffle public raffle;
HelperConfig public helperconfig;

address Player = makeAddr("Player");
uint256 constant STARTING_BALANCE = 10 ether;

    event raffleLogEntry(address indexed players);
    event raffleWinner(address indexed winner);



function setUp() external {
Deploycontract contractDeployed = new Deploycontract();
(helperconfig , raffle) = contractDeployed.contractLogic();

HelperConfig.NetworkConfig memory config = helperconfig.getConfig();

 uint256 entranceFee = config.entranceFee;
    uint256 intervalTime = config.intervalTime;
    address VRFCOORDINATOR = config.VRFCOORDINATOR;
     bytes32 gaslane= config.gaslane;
     uint256 subId= config.subId;
     uint32 callbackGasLimit= config.callbackGasLimit;

}


function testInsufficientFee() external{
    vm.prank(Player);
    vm.expectRevert(raffle.Raffle_InsufficientFee.selector);
    raffle.enterRaffle();
}



function testPlayersGettingAddedToFundersArray() external{

    vm.prank(Player);
    vm.deal(Player , STARTING_BALANCE);
    raffle.enterRaffle{value:entranceFee}();
    assert(Player == raffle.getPlayer(0));

}



function testEmitEnterRaffle() external{
    vm.prank(Player);
    vm.deal(Player , STARTING_BALANCE);
    vm.expectEmit(true,false,false,false,address(raffle));
    emit raffleLogEntry(Player);
raffle.enterRaffle{value:entranceFee}();
}













}