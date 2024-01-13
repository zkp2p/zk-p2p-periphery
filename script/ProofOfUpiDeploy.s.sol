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
        } else if (deployIdentifierHash == keccak256(abi.encodePacked("goerli_staging"))) {
            // Goerli
            ramp = IRampV2(address(0x7eDD66B19A22293af86A2d96761FD7146BA3fF6c));
        } else if (deployIdentifierHash == keccak256(abi.encodePacked("base_staging"))) {
            // Base staging
            ramp = IRampV2(address(0xc137d22fa93316Df55b5F896F5180c722D02b01D));
        } else if (deployIdentifierHash == keccak256(abi.encodePacked("base_production"))) {
            // Base production TODO
            ramp = IRampV2(address(1));
        } else {
            revert("Unsupported chain");
        }

        // Deploy NFT
        new ProofOfP2PNFTV2(
            ramp,
            "Proof of UPI-V1",
            "PoUPI-V1",
            "UPI",
            "FF9933",
            "FFFFFF",
            "138808",
            "138808"
        );

        vm.stopBroadcast();
    }
}
