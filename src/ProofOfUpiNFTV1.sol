// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { ERC721ReadOnly } from "./external/ERC721ReadOnly.sol";
import { IRampV2 } from "./interfaces/IRampV2.sol";
import { NFTDescriptorV2 } from "./lib/NFTDescriptorV2.sol";

contract ProofOfUpiNFTV1 is ERC721ReadOnly {

    /* ============ State Variables ============ */
    uint256 public currentTokenId;
    IRampV2 public ramp;
    mapping(address => uint256) internal addressToTokenId;

    /* ============ Constructor ============ */

    constructor(IRampV2 _ramp) ERC721ReadOnly('Proof of UPI-V1', 'PoUPI-V1') {
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
        IRampV2.AccountInfo memory accountInfo = ramp.getAccountInfo(msg.sender);

        // Check registration
        require(accountInfo.idHash != bytes32(0), "Not registered");

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
        IRampV2.AccountInfo memory accountInfo = ramp.getAccountInfo(owner);

        return
            NFTDescriptorV2.constructTokenURI(
                NFTDescriptorV2.ConstructTokenURIParams({
                    tokenId: tokenId,
                    idHash: accountInfo.idHash,
                    owner: owner,
                    platform: "UPI",
                    color0: "FF9933",
                    color1: "FFFFFF",
                    color2: "138808",
                    color3: "138808"
                })
            );
    }

    function getTokenId(address owner) public view returns (uint256) {
        return addressToTokenId[owner];
    }
}
