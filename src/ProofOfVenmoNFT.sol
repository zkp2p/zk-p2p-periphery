// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solmate/tokens/ERC721.sol";

contract ProofOfVenmoNFT is ERC721 {
    uint256 public currentTokenId;

    constructor() ERC721('Proof of Venmo-V1', 'PROVE-VENMO') {}

    function mintTo(address recipient) public returns (uint256) {
        // Read logic from Ramp

        // Check registration

        uint256 newTokenId = ++currentTokenId;
        _safeMint(recipient, newTokenId);
        return newTokenId;
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        return "";
    }

    function transferFrom(
        address /* from */,
        address /* to */,
        uint256 /* id */
    ) public override pure {
        revert("No transfers allowed");
    }
}
