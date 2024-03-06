// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {VaultToken} from "./VaultToken.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract TokenVault is ReentrancyGuard {

  VaultToken public token;

  mapping(address => uint) public balances;

  constructor(VaultToken _token) {
    token = _token;
  }

  function deposit() external payable nonReentrant {
    bool success = token.mint(msg.sender, msg.value);
    if (!success) {
      revert("Mint failed");
    }
  }

  function withdrawAll() external nonReentrant {
    uint256 balance = token.balanceOf(msg.sender);
    if (balance == 0) {
      revert("Insufficient balance");
    }

    (bool success, ) = msg.sender.call{value: balance}("");
    if (!success) {
      revert("Transfer failed");
    }
    success = token.burnAccount(msg.sender);
    if (!success) {
      revert("Burn failed");
    }
  }
}

