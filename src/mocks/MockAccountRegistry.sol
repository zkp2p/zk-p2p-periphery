// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { IAccountRegistry } from "../interfaces/IAccountRegistry.sol";

contract MockAccountRegistry is IAccountRegistry {

    mapping(address => bytes32) internal accounts;

    function setAccountId(address _account, bytes32 _idHash) external {
        accounts[_account] = _idHash;
    }

    function getAccountId(address _account) external view override returns(bytes32) {
        return accounts[_account];
    }
}
