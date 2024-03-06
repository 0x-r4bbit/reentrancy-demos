// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract SimpleNFT is ERC721Enumerable {

  uint256 private counter;

  mapping(address => bool) minted;

  constructor() ERC721("SimpleNFT", "SNFT") {}

  function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable) returns (bool) {
      return super.supportsInterface(interfaceId);
  }

  function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize) internal virtual override(ERC721Enumerable) {
    super._beforeTokenTransfer(from, to, tokenId, batchSize);
  }

  function mint() external payable {
    if (minted[msg.sender]) {
      revert("Already minted");
    }
    if (totalSupply() == 10) {
      revert("Max supply reached");
    }

    uint256 tokenId = counter;
    counter++;

    _safeMint(msg.sender, tokenId);
    minted[msg.sender] = true;
  }

}

