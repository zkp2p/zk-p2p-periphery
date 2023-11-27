//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

interface INFTDescription {
    function tokenURI(uint256 tokenId, address owner, bytes32 idHash, string memory platform, string memory logo) external view returns (string memory);
}
