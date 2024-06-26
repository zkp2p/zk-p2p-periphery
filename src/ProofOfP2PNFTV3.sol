// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { ERC721ReadOnly } from "./external/ERC721ReadOnly.sol";
import { IAccountRegistry } from "./interfaces/IAccountRegistry.sol";
import { NFTDescriptorV2 } from "./lib/NFTDescriptorV2.sol";

/// CHANGELOG:
/// - Make compatible with TLSN based ramps which uses IAccountRegistry to stored ID hash
contract ProofOfP2PNFTV3 is ERC721ReadOnly {

    /* ============ State Variables ============ */
    uint256 public currentTokenId;
    IAccountRegistry public accountRegistry;
    string public platform;
    string public color0;
    string public color1;
    string public color2;
    string public color3;

    mapping(address => uint256) internal addressToTokenId;

    /* ============ Constructor ============ */

    constructor(
        IAccountRegistry _accountRegistry,
        string memory _name,
        string memory _symbol,
        string memory _platform,
        string memory _color0,
        string memory _color1,
        string memory _color2,
        string memory _color3
    ) ERC721ReadOnly(_name, _symbol) {
        accountRegistry = _accountRegistry;
        platform = _platform;
        color0 = _color0;
        color1 = _color1;
        color2 = _color2;
        color3 = _color3;
    }

    /* ============ External Functions ============ */

    /**
     * @notice Mint a new soulbound NFT to the recipient
     *
     * @return tokenId The new token ID
     */
    function mintSBT() public returns (uint256) {
        // Read user ID from AccountRegistry
        bytes32 idHash = accountRegistry.getAccountId(msg.sender);

        // Check registration
        require(idHash != bytes32(0), "Not registered");

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
        bytes32 idHash = accountRegistry.getAccountId(owner);

        return
            NFTDescriptorV2.constructTokenURI(
                NFTDescriptorV2.ConstructTokenURIParams({
                    tokenId: tokenId,
                    idHash: idHash,
                    owner: owner,
                    platform: platform,
                    color0: color0,
                    color1: color1,
                    color2: color2,
                    color3: color3
                })
            );
    }

    function getTokenId(address owner) public view returns (uint256) {
        return addressToTokenId[owner];
    }
}
