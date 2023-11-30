// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Script, console2 } from "forge-std/Script.sol";
import { ProofOfP2PNFTV1, IRamp } from "../src/ProofOfP2PNFTV1.sol";

contract ProofOfVenmoNFTScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Ramp V1 Address on BASE
        IRamp ramp = IRamp(address(0xB084f36C5B7193af8Dd17025b36FBe2DD496a06f));

        // Deploy NFT
        new ProofOfP2PNFTV1(ramp);

        vm.stopBroadcast();
    }
}
