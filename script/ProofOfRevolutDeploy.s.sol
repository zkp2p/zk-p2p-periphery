// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Script, console2 } from "forge-std/Script.sol";
import { ProofOfP2PNFTV3, IAccountRegistry } from "../src/ProofOfP2PNFTV3.sol";

contract ProofOfRevolutDeployScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        string memory deployIdentifier = vm.envString("DEPLOY_IDENTIFIER");
        bytes32 deployIdentifierHash = keccak256(abi.encodePacked(deployIdentifier));

        vm.startBroadcast(deployerPrivateKey);

        // AccountRegistry Address
        IAccountRegistry accountRegistry;
        if (deployIdentifierHash == keccak256(abi.encodePacked("localhardhat"))) {
            // Hardhat
            accountRegistry = IAccountRegistry(address(0x8BBd158CFb23C3a1952B23d92b0536e7Bad6B3d9));
        } else if (deployIdentifierHash == keccak256(abi.encodePacked("sepolia_staging"))) {
            // Sepolia
            accountRegistry = IAccountRegistry(address(0x8BBd158CFb23C3a1952B23d92b0536e7Bad6B3d9));
        } else if (deployIdentifierHash == keccak256(abi.encodePacked("base_staging"))) {
            // Base staging. Skip staging deploy
            accountRegistry = IAccountRegistry(address(0));
        } else if (deployIdentifierHash == keccak256(abi.encodePacked("base_production"))) {
            // Base production: TODO
            accountRegistry = IAccountRegistry(address(0));
        } else {
            revert("Unsupported chain");
        }

        // Deploy NFT
        new ProofOfP2PNFTV3(
            accountRegistry,
            "Proof of Revolut",
            "PoRevolut",
            "Revolut",
            "001489",
            "012169",
            "C8102E",
            "FFDD00"
        );

        vm.stopBroadcast();
    }
}
