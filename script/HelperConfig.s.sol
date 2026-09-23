// SPDX-License-Identifier:MIT

pragma solidity 0.8.19;
import {Script} from "forge-std/Script.sol";



abstract contract DataConstants{
    uint256 constant ETH_MAINNET_CHAINID = 1;
    uint256 constant ETH_SEPOLIA_CHAINID =11155111 ;
    uint256 constant ANVIL_CHAINID = 31337;
}



contract HelperConfig is DataConstants,Script{

struct NetworkConfig{
    uint256 entranceFee;
    uint256 intervalTime;
    address VRFCOORDINATOR;
     bytes32 gaslane; 
     uint256 subId; 
     uint32 callbackGasLimit
     
}

NetworkConfig public config;

mapping(uint256 chainId => NetworkConfig chainConfig) private chainToConfig;



function getMainnet() public pure returns(NetworkConfig memory){
config = NetworkConfig({
    entranceFee:1 ether,
    intervalTime: 30,
VRFCOORDINATOR:0x271682DEB8C4E0901D1a1550aD2e64D568E69909,
gaslane:0xAA77729D3466CA35AE8D28B3BBAC7CC36A5031EFDC430821C02BC31A238AF445,
subId:,
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
subId:,
callbackGasLimit:5000
});
return config;
}








}