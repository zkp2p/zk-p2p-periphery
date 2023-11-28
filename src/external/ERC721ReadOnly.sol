// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

/**
 * Forked and modified from Arx Research: https://github.com/arx-research/ers-contracts/blob/master/contracts/token/ERC721ReadOnly.sol
 * CHANGELOG:
 * - Removed _exist and replaced with _ownerOf(tokenId) != address(0) which is removed in latest OpenZeppelin version 
 * - Removed extra safeTransferFrom because latest OpenZeppelin version removes `virtual` from function
 */

contract ERC721ReadOnly is ERC721 {
    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {}

    function approve(address /*to*/, uint256 /*tokenId*/) public virtual override {
        revert("ERC721 public approve not allowed");
    }

    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        require(_ownerOf(tokenId) != address(0), "ERC721: invalid token ID");
        return address(0);
    }

    function setApprovalForAll(address /*operator*/, bool /*approved*/) public virtual override {
        revert("ERC721 public setApprovalForAll not allowed");
    }

    function isApprovedForAll(address /*owner*/, address /*operator*/) public view virtual override returns (bool) {
        return false;
    }

    function transferFrom(address /*from*/, address /*to*/, uint256 /*tokenId*/) public virtual override {
        revert("ERC721 public transferFrom not allowed");
    }

    function safeTransferFrom(address /*from*/, address /*to*/, uint256 /*tokenId*/, bytes memory /*data*/) public virtual override {
        revert("ERC721 public safeTransferFrom not allowed");
    }
}