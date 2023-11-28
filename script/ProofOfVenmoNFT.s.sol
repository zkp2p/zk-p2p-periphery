// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Script, console2 } from "forge-std/Script.sol";
import { ProofOfVenmoNFT, IRamp } from "../src/ProofOfVenmoNFT.sol";

contract ProofOfVenmoNFTScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Ramp V1 Address on BASE
        IRamp ramp = IRamp(address(0xa08d9952196ABECB2BaCD14188093314053f6335));

        // Deploy NFT
        new ProofOfVenmoNFT(ramp);

        vm.stopBroadcast();
    }
}
