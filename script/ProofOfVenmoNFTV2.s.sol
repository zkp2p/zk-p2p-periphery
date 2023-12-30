// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Script, console2 } from "forge-std/Script.sol";
import { ProofOfVenmoNFTV2, IRampV2 } from "../src/ProofOfVenmoNFTV2.sol";

contract ProofOfVenmoNFTV2Script is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Ramp V2 Address on Goerli
        IRampV2 ramp = IRampV2(address(0xfD04fb0538479ad70DFae539c875B2C180205012));

        // Deploy NFT
        new ProofOfVenmoNFTV2(ramp);

        vm.stopBroadcast();
    }
}
