// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solmate/tokens/ERC721.sol";
import "./lib/NFTDescriptor.sol";

contract ProofOfVenmoNFT is ERC721 {
    uint256 public currentTokenId;
    address public ramp;
    string public venmoLogo;

    constructor(
        // address _ramp
    ) ERC721('Proof of Venmo-V1', 'PROVE-VENMO') {
        // ramp = _ramp;
        venmoLogo = string(
            abi.encodePacked(
                '<g style="transform:translate(87px, 185px)"><svg xmlns="http://www.w3.org/2000/svg" width="240" height="120" fill="#3d95ce"><path d="M29.793 21.444c.608 1.004.882 2.037.882 3.343 0 4.165-3.555 9.575-6.44 13.374h-6.6L15 22.356l5.77-.548 1.398 11.247c1.306-2.127 2.917-5.47 2.917-7.75 0-1.248-.214-2.097-.548-2.797zm7.48 6.96c1.062 0 3.735-.486 3.735-2.005 0-.73-.516-1.094-1.124-1.094-1.064 0-2.46 1.276-2.612 3.1zm-.122 3c0 1.855 1.032 2.583 2.4 2.583 1.5 0 2.915-.364 4.77-1.306l-.698 4.74c-1.306.638-3.34 1.064-5.317 1.064-5 0-6.805-3.04-6.805-6.838 0-4.924 2.917-10.153 8.932-10.153 3.3 0 5.163 1.855 5.163 4.44 0 4.165-5.345 5.44-8.444 5.47zm25.1-6.25c0 .608-.092 1.5-.184 2.066l-1.733 10.94h-5.62l1.58-10.03.122-1.124c0-.73-.456-.912-1.004-.912-.728 0-1.458.334-1.944.578l-1.792 11.5h-5.65l2.582-16.383h4.9l.062 1.308c1.154-.76 2.673-1.58 4.83-1.58 2.856 0 3.86 1.46 3.86 3.65zm16.68-1.856c1.6-1.154 3.13-1.793 5.224-1.793 2.885 0 3.9 1.46 3.9 3.65 0 .608-.092 1.5-.184 2.066l-1.73 10.94H80.5l1.6-10.243.092-.82c0-.822-.456-1.004-1.004-1.004-.698 0-1.396.304-1.914.578l-1.8 11.5h-5.62l1.6-10.243.1-.82c0-.822-.456-1.004-1.002-1.004-.73 0-1.458.334-1.944.578l-1.793 11.5h-5.65l2.58-16.383h4.83l.152 1.368c1.124-.82 2.642-1.64 4.677-1.64 1.762-.001 2.916.76 3.494 1.793zm20.296 4.772c0-1.337-.334-2.25-1.336-2.25-2.218 0-2.673 3.92-2.673 5.926 0 1.522.426 2.463 1.427 2.463 2.096 0 2.582-4.135 2.582-6.14zm-9.72 3.435c0-5.167 2.733-10 9.022-10 4.74 0 6.47 2.797 6.47 6.658 0 5.107-2.704 10.395-9.144 10.395-4.77 0-6.35-3.13-6.35-7.052z"/></svg></g>'
            )
        );
    }

    function mintTo(address recipient) public returns (uint256) {
        // Read logic from Ramp

        // Check registration

        uint256 newTokenId = ++currentTokenId;
        _safeMint(recipient, newTokenId);
        return newTokenId;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        address owner = ownerOf(tokenId);
        return
            NFTDescriptor.constructTokenURI(
                NFTDescriptor.ConstructTokenURIParams({
                    tokenId: tokenId,
                    idHash: bytes32(0x0741728e3aae72eda484e8ccbf00f843c38eae9c399b9bd7fb2b5ee7a055b6bf), // TODO: temp
                    owner: owner,
                    platform: "Venmo",
                    logo: venmoLogo
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
