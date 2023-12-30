// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Script, console2 } from "forge-std/Script.sol";
import { ProofOfUpiNFTV1, IRampV2 } from "../src/ProofOfUpiNFTV1.sol";

contract ProofOfUpiNFTV1Script is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Ramp V2 Address on Goerli
        IRampV2 ramp = IRampV2(address(0x7edd66b19a22293af86a2d96761fd7146ba3ff6c));

        // Deploy NFT
        new ProofOfUpiNFTV1(ramp);

        vm.stopBroadcast();
    }
}
