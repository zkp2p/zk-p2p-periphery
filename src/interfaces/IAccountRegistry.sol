//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

interface IAccountRegistry {
    function getAccountId(address _account) external view returns (bytes32);
}