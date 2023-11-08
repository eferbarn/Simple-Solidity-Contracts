// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTBatchTransfer is Ownable {
    IERC721 public nftContract;

    constructor(address _nftContractAddress, address _initialOwner) Ownable(_initialOwner) {
        nftContract = IERC721(_nftContractAddress);
    }

    function batchSafeTransferFrom(
        address[] memory toAddresses,
        uint256[] memory tokenIds
    ) public onlyOwner {
        // Logical Double-Checks
        require(
            toAddresses.length == tokenIds.length, 
            "Input arrays must have the same length"
        );
        // Check if the contract is approved to transfer
        // the token from the owner's address
        require(
            nftContract.isApprovedForAll(msg.sender, address(this)), 
            "Contract not approved to transfer NFT"
        );


        for (uint256 i = 0; i < toAddresses.length; i++) {
            address to = toAddresses[i];
            uint256 tokenId = tokenIds[i];
            nftContract.safeTransferFrom(msg.sender, to, tokenId);
        }
    }
}
