// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SimpleNFT} from "../src/SimpleNFT.sol";
import {SimpleNFTAttack} from "../src/SimpleNFTAttack.sol";

contract SimpleNFTAttackTest is Test {

    SimpleNFT public simpleNFT;
    SimpleNFTAttack public attack;

    function setUp() public {
      simpleNFT = new SimpleNFT();
      attack = new SimpleNFTAttack(simpleNFT);
    }

    function testReentrancy() public {
      attack.attack();

      assertEq(simpleNFT.totalSupply(), 10);
      assertEq(simpleNFT.balanceOf(address(attack)), 10);
    }
}
