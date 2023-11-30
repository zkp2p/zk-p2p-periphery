// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { ERC721ReadOnly } from "./external/ERC721ReadOnly.sol";
import { IRamp } from "./interfaces/IRamp.sol";
import { NFTDescriptor } from "./lib/NFTDescriptor.sol";

contract ProofOfP2PNFTV1 is ERC721ReadOnly {

    /* ============ State Variables ============ */
    uint256 public currentTokenId;
    IRamp public ramp;
    mapping(address => uint256) internal addressToTokenId;

    /* ============ Constructor ============ */

    constructor(IRamp _ramp) ERC721ReadOnly('Proof of P2P-V1', 'PoP2P') {
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
            NFTDescriptor.constructTokenURI(
                NFTDescriptor.ConstructTokenURIParams({
                    tokenId: tokenId,
                    idHash: accountInfo.venmoIdHash,
                    owner: owner,
                    platform: "ZKP2P"
                })
            );
    }

    function getTokenId(address owner) public view returns (uint256) {
        return addressToTokenId[owner];
    }
}
