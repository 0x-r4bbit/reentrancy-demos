// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SimpleVault} from "../src/SimpleVault.sol";
import {SimpleVaultAttack} from "../src/SimpleVaultAttack.sol";

contract SimpleVaultAttackTest is Test {

    SimpleVault public simpleVault;
    SimpleVaultAttack public attack;

    function setUp() public {
      simpleVault = new SimpleVault();
      attack = new SimpleVaultAttack(simpleVault);
    }

    function testReentrancy() public {

      // create users
      address alice = payable(makeAddr("alice"));
      address bob = payable(makeAddr("bob"));

      // make sure they have funds
      vm.deal(alice, 2 ether);
      vm.deal(bob, 2 ether);

      // deposit into vault as users
      vm.prank(alice);
      simpleVault.deposit{value: 2 ether}();
      vm.prank(bob);
      simpleVault.deposit{value: 2 ether}();

      // ensure vault has funds
      assertEq(address(simpleVault).balance, 4 ether);

      attack.attack{value: 1 ether}();

      assertEq(address(simpleVault).balance, 0 ether);
      assertEq(address(attack).balance, 5 ether);
    }

}
