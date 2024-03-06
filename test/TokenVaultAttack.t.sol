// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TokenVault} from "../src/TokenVault.sol";
import {VaultToken} from "../src/VaultToken.sol";
import {TokenVaultAttack} from "../src/TokenVaultAttack.sol";

contract TokenVaultAttackTest is Test {

    TokenVault public vault;
    VaultToken public token;
    TokenVaultAttack public attacker;
    TokenVaultAttack public peer;

    function setUp() public {
      token = new VaultToken();
      vault = new TokenVault(token);
      attacker = new TokenVaultAttack(vault, token);
      peer = new TokenVaultAttack(vault, token);

      token.transferOwnership(address(vault));
      attacker.setPeer(peer);
      peer.setPeer(attacker);
    }

    function testReentrancy() public {

      // create users
      address alice = payable(makeAddr("alice"));
      address bob = payable(makeAddr("bob"));
      address charly = payable(makeAddr("charly"));

      // make sure they have funds
      vm.deal(alice, 2 ether);
      vm.deal(bob, 2 ether);
      vm.deal(charly, 2 ether);

      // deposit into vault as users
      vm.prank(alice);
      vault.deposit{value: 2 ether}();
      vm.prank(bob);
      vault.deposit{value: 2 ether}();
      vm.prank(charly);
      vault.deposit{value: 2 ether}();

      // check that tokens have been minted correctly
      assertEq(address(vault).balance, 6 ether);
      assertEq(token.balanceOf(address(vault)), 0);
      assertEq(token.balanceOf(address(alice)), 2 ether);
      assertEq(token.balanceOf(address(bob)), 2 ether);
      assertEq(token.balanceOf(address(charly)), 2 ether);

      // perform first attack
      attacker.attack{value: 1 ether}();

      // check that attacker got eth back and peer got tokens
      assertEq(address(vault).balance, 6 ether);
      assertEq(address(attacker).balance, 1 ether);
      assertEq(address(peer).balance, 0);

      assertEq(token.balanceOf(address(attacker)), 0);
      assertEq(token.balanceOf(address(peer)), 1 ether);

      // perform second attack
      peer.attackNext();

      assertEq(address(vault).balance, 5 ether);
      assertEq(address(attacker).balance, 1 ether);
      assertEq(address(peer).balance, 1 ether);

      assertEq(token.balanceOf(address(attacker)), 1 ether);
      assertEq(token.balanceOf(address(peer)), 0);

      // perform third attack
      attacker.attackNext();

      assertEq(address(vault).balance, 4 ether);
      assertEq(address(attacker).balance, 2 ether);
      assertEq(address(peer).balance, 1 ether);

      assertEq(token.balanceOf(address(attacker)), 0);
      assertEq(token.balanceOf(address(peer)), 1 ether);
    }
}

