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
            accountRegistry = IAccountRegistry(address(0x4b6db2939E09A642afb90cEd37126213aBbA0f4F));
        } else if (deployIdentifierHash == keccak256(abi.encodePacked("sepolia_staging"))) {
            // Sepolia
            accountRegistry = IAccountRegistry(address(0x4b6db2939E09A642afb90cEd37126213aBbA0f4F));
        } else if (deployIdentifierHash == keccak256(abi.encodePacked("base_staging"))) {
            // Base staging
            accountRegistry = IAccountRegistry(address(0x44115b15Ff0Db10702DFC72Cb2fd3179215623df));
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
            "FFDD00",
            "FFDD00"
        );

        vm.stopBroadcast();
    }
}
