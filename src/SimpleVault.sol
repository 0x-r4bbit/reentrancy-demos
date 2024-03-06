// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract SimpleVault {

  mapping(address => uint) public balances;

  function deposit() external payable {
    if (msg.value < 1 ether) {
      revert("Insufficient amount");
    }
    balances[msg.sender] += msg.value;
  }

  function withdraw() external {
    if (balances[msg.sender] == 0) {
      revert("Insufficient balance");
    }

    uint256 balance = balances[msg.sender];
    balances[msg.sender] = 0;
    (bool success, ) = msg.sender.call{value: balance}("");
    if (!success) {
      revert("Transfer failed");
    }
  }
}
