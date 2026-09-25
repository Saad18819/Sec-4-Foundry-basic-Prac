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

function setUp() external {
Deploycontract contractDeployed = new Deploycontract();
(helperconfig , raffle) = contractDeployed.contractLogic();

HelperConfig.NetworkConfig memory config = 
}


function testInsufficientFee() external{
    vm.prank(Player);
    vm.expectRevert(raffle.Raffle_InsufficientFee.selector);
    raffle.enterRaffle();
}


function testPlayersGettingAddedToFundersArray() external{
    vm.prank(Player);
    vm.deal(Player , STARTING_BALANCE);
    raffle.enterRaffle{value:}
}







}