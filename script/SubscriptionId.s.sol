// SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {LinkToken} from "test/mocks/LinkToken.sol";

contract Subs is Script{

function run() public returns(uint256,address){
return CreateConfigSub();
}

function CreateConfigSub() public returns(uint256 , address){


HelperConfig helperconfig = new HelperConfig();
HelperConfig.NetworkConfig memory config =  helperconfig. getConfig();
address vrfcoordinator = config.VRFCOORDINATOR;

uint256 SubId= CreateSubs(vrfcoordinator);

return (SubId,vrfcoordinator);


}


function CreateSubs(address vrfCoordinator) public returns(uint256){

vm.startBroadcast();
uint256 subId = VRFCoordinatorV2_5Mock(vrfCoordinator).createSubscription();
vm.stopBroadcast
return subId;


}


}


contract FundSubscription is Script,DataConstants{
    uint256 public constant FUND_AMOUNT = 3 ether;


function fundSubConfig() public{
    HelperConfig helperconfig = new HelperConfig();
    HelperConfig.NetworkConfig memory config = helperconfig.getConfig();
    address vrf = config.VRFCOORDINATOR;
    uint256 subsId = config.subId;
    address linkToken = config.link;
    fundSubs(vrf,subsId,linkToken);

}


    function fundSubs(address vrfCoordinator , uint256 SubsId , address linkToken) public {

        if(block.chainid == ANVIL_CHAINID){
             vm.startBroadcast();
  VRFCoordinatorV2_5Mock(vrfCoordinator).fundSubscription(subscriptionId , FUND_AMOUNT);
vm.stopBroadcast();
        }
        else{
            vm.startBroadcast();
            LinkToken(linktoken).transferAndCall(vrfCoordinator, FUND_AMOUNT , abi.encode(SubsId));
            vm.stopBroadcast();
        }
    }

function run() external{
    fundSubConfig();
}



}