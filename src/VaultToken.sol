// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract VaultToken is Ownable, ERC20 {
    constructor() ERC20("Vault Token", "VLT") {}

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function mint(address recipient, uint256 amount) public onlyOwner returns (bool) {
        _mint(recipient, amount);
        return true;
    }

    function burnAccount(address account) external onlyOwner returns(bool){
        _burn(account, balanceOf(account));
        return true;
    }
}

