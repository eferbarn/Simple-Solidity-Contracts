// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTBatchTransfer is Ownable {
    IERC1155 public nftContract;

    constructor(address _nftContractAddress, address _initialOwner) Ownable(_initialOwner) {
        nftContract = IERC1155(_nftContractAddress);
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
            nftContract.safeTransferFrom(msg.sender, to, tokenId, amount, data);
        }
    }
}
