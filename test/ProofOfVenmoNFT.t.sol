// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {IRamp} from "../src/interfaces/IRamp.sol";
import {MockRamp} from "../src/mocks/MockRamp.sol";
import {NFTDescription} from "../src/NFTDescription.sol";
import {ProofOfVenmoNFT} from "../src/ProofOfVenmoNFT.sol";

contract ProofOfVenmoNFTTest is Test {
    ProofOfVenmoNFT public proofOfVenmoNFT;
    NFTDescription public nftDescription;
    MockRamp public ramp;

    function setUp() public {
        nftDescription = new NFTDescription();
        ramp = new MockRamp();

        ramp.setAccountInfo(
            address(address(0x1000000000000000000000000000000000000001)),
            IRamp.AccountInfo({
                venmoIdHash: bytes32(0x0741728e3aae72eda484e8ccbf00f843c38eae9c399b9bd7fb2b5ee7a055b6bf),
                deposits: new uint256[](0)
            })
        );
        IRamp.AccountInfo memory accountInfo = ramp.getAccountInfo(address(0x1000000000000000000000000000000000000001));

        proofOfVenmoNFT = new ProofOfVenmoNFT(
            ramp,
            nftDescription
        );
    }

    function test_svg() public {
        proofOfVenmoNFT.mintTo(address(0x1000000000000000000000000000000000000001));
        console2.log(proofOfVenmoNFT.tokenURI(1));
    }
}
