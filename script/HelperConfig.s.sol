// SPDX-License-Identifier:MIT

pragma solidity 0.8.19;
import {Script} from "forge-std/Script.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/vrf/mocks/VRFCoordinatorV2_5Mock.sol";


abstract contract DataConstants{
    uint256 constant ETH_MAINNET_CHAINID = 1;
    uint256 constant ETH_SEPOLIA_CHAINID =11155111 ;
    uint256 constant ANVIL_CHAINID = 31337;
    uint96 constant BASE_FEE =  0.5 ether;
    uint96 constant GAS_FEE= 1e15;
     int256 constant WEI_PER_LINK = 1e9;
}



contract HelperConfig is DataConstants,Script{

error invalidChainId();


struct NetworkConfig{
    uint256 entranceFee;
    uint256 intervalTime;
    address VRFCOORDINATOR;
     bytes32 gaslane; 
     uint256 subId; 
     uint32 callbackGasLimit;
     
}

NetworkConfig public config;

mapping(uint256 chainId => NetworkConfig chainConfig) private chainToConfig;


function getConfig(uint256 chainId) public view returns(NetworkConfig memory){
    if(chainToConfig[chainId].VRFCOORDINATOR != address(0)){
        return chainToConfig[chainId];
    }
    else if(chainId == ANVIL_CHAINID){
        return getAnvil();
    }else{
        revert invalidChainId();
    }
}




function getMainnet() public pure returns(NetworkConfig memory){
config = NetworkConfig({
    entranceFee:1 ether,
    intervalTime: 30,
VRFCOORDINATOR:0x271682DEB8C4E0901D1a1550aD2e64D568E69909,
gaslane:0xAA77729D3466CA35AE8D28B3BBAC7CC36A5031EFDC430821C02BC31A238AF445,
subId:0,
callbackGasLimit:5000
});
return config;
}





function getSepolia() public pure returns(NetworkConfig memory){
    config = NetworkConfig({
    entranceFee:1 ether,
    intervalTime: 30,
VRFCOORDINATOR:0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625,
gaslane:0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c,
subId:0,
callbackGasLimit:5000
});
return config;
}



function getAnvil() public returns(NetworkConfig memory){

if(config.VRFCOORDINATOR != address(0)){
    return config;
}

vm.startBroadcast();

VRFCoordinatorV2_5Mock mocking = new VRFCoordinatorV2_5Mock(BASE_FEE,GAS_FEE,WEI_PER_LINK);

vm.stopBroadcast();


config = NetworkConfig({
    entranceFee:1 ether,
    intervalTime: 30,
VRFCOORDINATOR:address(mocking),
gaslane:0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c,
subId:0,
callbackGasLimit:5000
});
return config;


}










}


/*
LEARNINGS

Sepolia / Mainnet (getSepoliaEthConfig)
No if check needed.The contracts already exist live on-chain. The function simply returns hardcoded constant values from memory, costing zero gas and creating no side effects.  

 Anvil / Local Chain (getOrCreateAnvilEthConfig)if check is required: 
 if (localNetworkConfig.vrfCoordinator != address(0))   
 Why: On local chains, the Chainlink contracts do not exist yet, so we must deploy a mock contract on the fly using new VRFCoordinatorV2_5Mock(...).  
 Purpose: The if check acts as a singleton cache. It ensures the mock is deployed only once. Subsequent calls return the saved address from localNetworkConfig, preventing duplicate mock deployments that would break tests




Scenario WITHOUT the if check (The Bug)


Imagine you write a test suite in Foundry with 2 separate tests: Test A and Test B.




Test A runs:It calls helperConfig.getConfig().getOrCreateAnvilEthConfig() runs, deploys Mock #1 at address 0x111....   Your script creates a Chainlink Subscription on Mock #1 (0x111...) and adds your Raffle contract as a consumer.Test A passes!
Test B runs immediately after:It calls helperConfig.getConfig().getOrCreateAnvilEthConfig() runs again, deploying Mock #2 at address 0x222...!   Your Raffle contract is deployed, but it tries to request random words from Mock #2 (0x222...).BOOM! Test B fails.
 Why? Because subscription funding and consumer registration happened on Mock #1, but Raffle is trying to call Mock #2 which knows nothing about your subscription!

 */