//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

interface IRamp {
    struct AccountInfo {
        bytes32 venmoIdHash;                // Poseidon hash of account's venmoId
        uint256[] deposits;                 // Array of open account deposits
    }

    function getAccountInfo(address _account) external view returns(AccountInfo memory);
}
