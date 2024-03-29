// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Script, console2 } from "forge-std/Script.sol";
import { ProofOfP2PNFTV2, IRampV2 } from "../src/ProofOfP2PNFTV2.sol";

contract ProofOfGarantiDeployScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        string memory deployIdentifier = vm.envString("DEPLOY_IDENTIFIER");
        bytes32 deployIdentifierHash = keccak256(abi.encodePacked(deployIdentifier));

        vm.startBroadcast(deployerPrivateKey);

        // Ramp V2 Address
        IRampV2 ramp;
        if (deployIdentifierHash == keccak256(abi.encodePacked("localhardhat"))) {
            // Hardhat
            ramp = IRampV2(address(0x9E545E3C0baAB3E08CdfD552C960A1050f373042));
        } else if (deployIdentifierHash == keccak256(abi.encodePacked("sepolia_staging"))) {
            // Sepolia
            ramp = IRampV2(address(0xEfBDf422FA81071A04D2f89A70A0D938FEFA0795));
        } else if (deployIdentifierHash == keccak256(abi.encodePacked("base_staging"))) {
            // Base staging. Skip staging deploy
            ramp = IRampV2(address(0));
        } else if (deployIdentifierHash == keccak256(abi.encodePacked("base_production"))) {
            // Base production
            ramp = IRampV2(address(0x4Edc42B8925CF307C3DD5e7Fd9a3B04453A3e37d));
        } else {
            revert("Unsupported chain");
        }

        // Deploy NFT
        new ProofOfP2PNFTV2(
            ramp,
            "Proof of Garanti-V1",
            "PoBBVA-V1",
            "Garanti BBVA",
            "C8102E",
            "77DDE7",
            "30D5C8",
            "D35400"
        );

        vm.stopBroadcast();
    }
}
