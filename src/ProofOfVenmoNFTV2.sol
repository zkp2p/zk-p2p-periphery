// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { ERC721ReadOnly } from "./external/ERC721ReadOnly.sol";
import { IRamp } from "./interfaces/IRamp.sol";
import { NFTDescriptorV2 } from "./lib/NFTDescriptorV2.sol";

contract ProofOfVenmoNFTV2 is ERC721ReadOnly {

    /* ============ State Variables ============ */
    uint256 public currentTokenId;
    IRamp public ramp;
    mapping(address => uint256) internal addressToTokenId;

    /* ============ Constructor ============ */

    constructor(IRamp _ramp) ERC721ReadOnly('Proof of Venmo-V2', 'PoP2P-V2') {
        ramp = _ramp;
    }

    /* ============ External Functions ============ */

    /**
     * @notice Mint a new soulbound NFT to the recipient
     *
     * @return tokenId The new token ID
     */
    function mintSBT() public returns (uint256) {
        // Read user ID from Ramp
        IRamp.AccountInfo memory accountInfo = ramp.getAccountInfo(msg.sender);

        // Check registration
        require(accountInfo.venmoIdHash != bytes32(0), "Not registered");

        // Check NFT has not been minted for address
        // Note: tokenId starts at 1, so this check is valid
        require(addressToTokenId[msg.sender] == 0, "Already minted for owner");
        
        // Nullify NFT mint for address
        uint256 newTokenId = ++currentTokenId;
        addressToTokenId[msg.sender] = newTokenId;

        _safeMint(msg.sender, newTokenId);

        return newTokenId;
    }

    /* ============ External View Functions ============ */

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        address owner = ownerOf(tokenId);
        IRamp.AccountInfo memory accountInfo = ramp.getAccountInfo(owner);

        return
            NFTDescriptorV2.constructTokenURI(
                NFTDescriptorV2.ConstructTokenURIParams({
                    tokenId: tokenId,
                    idHash: accountInfo.venmoIdHash,
                    owner: owner,
                    platform: "Venmo",
                    color0: "3B389D",
                    color1: "F36D60",
                    color2: "3F9347",
                    color3: "721B78"
                })
            );
    }

    function getTokenId(address owner) public view returns (uint256) {
        return addressToTokenId[owner];
    }
}
