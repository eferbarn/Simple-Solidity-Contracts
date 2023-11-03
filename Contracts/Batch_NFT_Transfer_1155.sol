// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC1155BatchTransfer is Ownable {
    // Address of the ERC-1155 token contract
    IERC1155 public erc1155Contract;

    constructor(address _erc1155ContractAddress) {
        erc1155Contract = IERC1155(_erc1155ContractAddress);
    }

    function batchSafeTransferFrom(
        address[] memory toAddresses,
        uint256[] memory tokenIds,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyOwner {
        require(
            toAddresses.length == tokenIds.length && tokenIds.length == amounts.length,
            "Input arrays must have the same length"
        );

        for (uint256 i = 0; i < toAddresses.length; i++) {
            address to = toAddresses[i];
            uint256 tokenId = tokenIds[i];
            uint256 amount = amounts[i];
            erc1155Contract.safeTransferFrom(msg.sender, to, tokenId, amount, data);
        }
    }
}
