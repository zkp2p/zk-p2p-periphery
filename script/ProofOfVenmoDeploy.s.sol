// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Script, console2 } from "forge-std/Script.sol";
import { ProofOfP2PNFTV2Venmo, IRamp } from "../src/ProofOfP2PNFTV2Venmo.sol";

contract ProofOfVenmoDeployScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        string memory deployIdentifier = vm.envString("DEPLOY_IDENTIFIER");
        bytes32 deployIdentifierHash = keccak256(abi.encodePacked(deployIdentifier));
        vm.startBroadcast(deployerPrivateKey);

        // Ramp V2 Address
        IRamp ramp;
        if (deployIdentifierHash == keccak256(abi.encodePacked("localhardhat"))) {
            // Hardhat
            ramp = IRamp(address(0xa85233C63b9Ee964Add6F2cffe00Fd84eb32338f));
        } else if (deployIdentifierHash == keccak256(abi.encodePacked("sepolia_staging"))) {
            // Sepolia
            ramp = IRamp(address(0x38637CD256d70994f2d5533BEAfe52eEfC2a96Ab));
        } else if (deployIdentifierHash == keccak256(abi.encodePacked("base_staging"))) {
            // Base staging
            ramp = IRamp(address(0x80e5aB2921e23192B2454f6a386Fd7032dad932E));
        } else if (deployIdentifierHash == keccak256(abi.encodePacked("base_production"))) {
            // Base production TODO
            ramp = IRamp(address(1));
        } else {
            revert("Unsupported chain");
        }

        // Deploy NFT
        new ProofOfP2PNFTV2Venmo(ramp);

        vm.stopBroadcast();
    }
}
