// SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

import {Test} from "forge-std/Test.sol";
import {Raffle} from "../src/Raffle.sol";
import { Deploycontract} from "../script/DeployScript.s.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {Vm} from "forge-std/Vm.sol";


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

function testInitialStateOpen() external view{
assert(raffle.getRaffleState() == Raffle.raffleState.Open);
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


function testCantEnterWhileCalculating() external{
    vm.prank(Player);
    vm.deal(Player,STARTING_BALANCE);
    raffle.enterRaffle{value:entranceFee}();
    vm.warp(block.timestamp + 30 + 1);
    vm.roll(block.number + 1);
    raffle.performUpKeep("");
    vm.prank(Player);
    expectRevert(raffle.Raffle_raffleEntryClosed.selector);
    raffle.enterRaffle{value:entranceFee}();
}


function testCheckupKeepReturnsFalseWhenNoBalance() public{
    vm.warp(block.timestamp + intervalTime + 1);
    vm.roll(block.number + 1);
(bool upKeep,) = raffle.checkUpkeep("");
    assert(!upKeep);
}

function testCheckupKeepReturnsFalseWhenStateOpen() public{
  vm.deal(Player,STARTING_BALANCE);
  vm.prank(Player);
   raffle.enterRaffle{value:entranceFee}();
    vm.warp(block.timestamp + 30 + 1);
    vm.roll(block.number + 1);

   raffle.performUpKeep("");
   (bool upKeep,) = raffle.checkUpkeep("");

   assert(!upKeep);
}


function testUpkeepOnlyWorksWhenCheckUpKeepTrue() public{
     vm.deal(Player,STARTING_BALANCE);
  vm.prank(Player);
   raffle.enterRaffle{value:entranceFee}();
    vm.warp(block.timestamp + 30 + 1);
    vm.roll(block.number + 1);

   raffle.performUpKeep("");
}

function testPerformUpKeepRevert() public{
    uint256 balance = 0;
    uint256 player = 0;
    Raffle.raffleState rState = raffle.getRaffleState();
       vm.deal(Player,STARTING_BALANCE);
  vm.prank(Player);
   raffle.enterRaffle{value:entranceFee}();
   balance = balance + entranceFee;
   player = player +1;

   vm.expectRevert(abi.encodeWithSelector(Raffle.Raffle_UpKeepNotTrue.selector , balance,player,rState));
  raffle.performUpKeep("");
}

function testCheckUpKeepEmit() public{
 vm.deal(Player,STARTING_BALANCE);
  vm.prank(Player);
   raffle.enterRaffle{value:entranceFee}();
    vm.warp(block.timestamp + 30 + 1);
    vm.roll(block.number + 1);

    vm.recordLogs();
     raffle.performUpKeep("");
     Vm.Log[] memory entries = vm.getRecordedLogs(); 
    bytes32 requestId = entries[1].topics[1];

    assert(requestId>0);

}




}