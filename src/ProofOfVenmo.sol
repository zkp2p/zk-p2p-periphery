// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


contract ProofOfVenmo is ERC721Permit {
    uint256 public number;

    constructor() ERC721('Proof of Venmo-V1', 'PROVE-VENMO', '1') {}

    function increment() public {
        number++;
    }
}
