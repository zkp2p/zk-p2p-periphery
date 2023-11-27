// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../interfaces/IRamp.sol";

contract MockRamp is IRamp {

    mapping(address => AccountInfo) internal accounts;

    function setAccountInfo(address _account, AccountInfo memory _accountInfo) external {
        accounts[_account] = _accountInfo;
    }

    function getAccountInfo(address _account) external view override returns(AccountInfo memory) {
        return accounts[_account];
    }
}
