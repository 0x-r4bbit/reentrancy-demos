// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract SimpleVault is ReentrancyGuard {

  mapping(address => uint) public balances;

  function deposit() external payable {
    if (msg.value < 1 ether) {
      revert("Insufficient amount");
    }
    balances[msg.sender] += msg.value;
  }

  function withdraw() external nonReentrant {
    if (balances[msg.sender] == 0) {
      revert("Insufficient balance");
    }

    uint256 balance = balances[msg.sender];
    (bool success, ) = msg.sender.call{value: balance}("");
    if (!success) {
      revert("Transfer failed");
    }

    balances[msg.sender] = 0;
  }
}
