// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {ProofOfVenmoNFT} from "../src/ProofOfVenmoNFT.sol";

contract ProofOfVenmoNFTTest is Test {
    ProofOfVenmoNFT public proofOfVenmoNFT;

    function setUp() public {
        proofOfVenmoNFT = new ProofOfVenmoNFT();
    }

    function test_svg() public {
        proofOfVenmoNFT.mintTo(address(0x1110000000000000000000000000000000000001));
        console2.log(proofOfVenmoNFT.tokenURI(0));
    }
}
