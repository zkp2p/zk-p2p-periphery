// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solmate/tokens/ERC721.sol";
import "./lib/NFTDescriptor.sol";

contract ProofOfVenmoNFT is ERC721 {
    uint256 public currentTokenId;
    address public ramp;

    constructor(
        // address _ramp
    ) ERC721('Proof of Venmo-V1', 'PROVE-VENMO') {
        // ramp = _ramp;
    }

    function mintTo(address recipient) public returns (uint256) {
        // Read logic from Ramp

        // Check registration

        uint256 newTokenId = ++currentTokenId;
        _safeMint(recipient, newTokenId);
        return newTokenId;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return
            NFTDescriptor.constructTokenURI(
                NFTDescriptor.ConstructTokenURIParams({
                    tokenId: tokenId,
                    venmoIdHash: bytes32(0x0741728e3aae72eda484e8ccbf00f843c38eae9c399b9bd7fb2b5ee7a055b6bf) // TODO: temp
                })
            );
    }

    function transferFrom(
        address /* from */,
        address /* to */,
        uint256 /* id */
    ) public override pure {
        revert("No transfers allowed");
    }
}
