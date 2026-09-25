// SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

import {Test} from "forge-std/Test.sol";
import {Raffle} from "../src/Raffle.sol";
import { Deploycontract} from "../script/DeployScript.s.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract RaffleTest is Test{
Raffle public raffle;
HelperConfig public helperconfig;



function setUp() external {
Deploycontract contractDeployed = new Deploycontract();
(helperconfig , raffle) = contractDeployed.contractLogic();
}





}