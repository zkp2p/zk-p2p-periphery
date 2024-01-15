// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Script, console2 } from "forge-std/Script.sol";
import { ProofOfP2PNFTV2, IRampV2 } from "../src/ProofOfP2PNFTV2.sol";

contract ProofOfUpiDeployScript is Script {
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
            ramp = IRampV2(address(0x0B306BF915C4d645ff596e518fAf3F9669b97016));
        } else if (deployIdentifierHash == keccak256(abi.encodePacked("sepolia_staging"))) {
            // Sepolia
            ramp = IRampV2(address(0xb4A7486b0EFa264D5FC6A8181bfc7A150cD57849));
        } else if (deployIdentifierHash == keccak256(abi.encodePacked("base_staging"))) {
            // Base staging
            ramp = IRampV2(address(0xc137d22fa93316Df55b5F896F5180c722D02b01D));
        } else if (deployIdentifierHash == keccak256(abi.encodePacked("base_production"))) {
            // Base production
            ramp = IRampV2(address(0xf3c9a6CA0DF1950a62ea868704678b1e8C34918a));
        } else {
            revert("Unsupported chain");
        }

        // Deploy NFT
        new ProofOfP2PNFTV2(
            ramp,
            "Proof of UPI-V1",
            "PoUPI-V1",
            "UPI",
            "008080",
            "00A693",
            "FFD700",
            "8E4585"
        );

        vm.stopBroadcast();
    }
}
