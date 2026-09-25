// SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {Raffle} from "../src/Raffle.sol";


contract Deploycontract is Script {
    function run() public {
        return contractLogic();
    }

    function contractLogic() public returns(HelperConfig,Raffle) {
HelperConfig deployConfig = new HelperConfig();
HelperConfig.NetworkConfig memory raffleConfig = deployConfig.getConfig();

vm.startBroadcast();
Raffle raffle = new Raffle(
raffleConfig.entranceFee,
raffleConfig.intervalTime
raffleConfig.VRFCOORDINATOR
raffleConfig.gaslane
raffleConfig.subId
raffleConfig.callbackGasLimit

);
vm.stopBroadcast();

return (deployConfig , raffle);

    }
}

