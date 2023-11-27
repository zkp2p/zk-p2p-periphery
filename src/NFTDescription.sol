// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "solmate/tokens/ERC721.sol";
import "./interfaces/INFTDescription.sol";
import "./lib/NFTDescriptor.sol";

contract NFTDescription is INFTDescription {
    function tokenURI(
        uint256 tokenId,
        address owner,
        bytes32 idHash,
        string memory platform,
        string memory logo
    )
        external
        pure
        returns
        (string memory)
    {
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
