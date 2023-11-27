// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "solmate/tokens/ERC721.sol";
import "./interfaces/IDescription.sol";
import "./lib/NFTDescriptor.sol";

contract Description is IDescription {
    function tokenURI(uint256 tokenId, address owner, bytes32 idHash, string memory platform, string memory logo) external view returns (string memory) {
        return
            NFTDescriptor.constructTokenURI(
                NFTDescriptor.ConstructTokenURIParams({
                    tokenId: tokenId,
                    idHash: idHash,
                    owner: owner,
                    platform: platform,
                    logo: logo
                })
            );
    }
}
