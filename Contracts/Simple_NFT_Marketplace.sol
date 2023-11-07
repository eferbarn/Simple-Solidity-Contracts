// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract NFTMarketplace {
    address public owner;
    IERC20 public paymentToken; // The token used for payments

    struct Listing {
        address seller;
        uint256 tokenId;
        uint256 price;
        bool isERC1155;
    }

    Listing[] public listings;

    event NFTListed(
        address indexed seller,
        uint256 indexed tokenId, 
        uint256 price, 
        bool isERC1155
    );
    event NFTSold(
        address indexed seller, 
        address indexed buyer, 
        uint256 indexed tokenId, 
        uint256 price, 
        bool isERC1155
    );

    constructor(address _paymentToken) {
        owner = msg.sender;
        paymentToken = IERC20(_paymentToken);
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the owner can call this function"
        );
        _;
    }

    function listNFT(
        uint256 _tokenId, uint256 _price, bool _isERC1155
    ) public {
        require(_price > 0, "Price must be greater than 0");
        if (_isERC1155) {
            IERC1155 erc1155 = IERC1155(msg.sender);
            require(
                erc1155.balanceOf(msg.sender, _tokenId) > 0, 
                "Sender does not own the specified ERC-1155 token"
            );
        } else {
            IERC721 erc721 = IERC721(msg.sender);
            require(
                erc721.ownerOf(_tokenId) == msg.sender, 
                "Sender does not own the specified ERC-721 token"
            );
        }

        listings.push(Listing({
            seller: msg.sender,
            tokenId: _tokenId,
            price: _price,
            isERC1155: _isERC1155
        }));

        emit NFTListed(msg.sender, _tokenId, _price, _isERC1155);
    }

    function buyNFT(uint256 _listingIndex) public {
        require(_listingIndex < listings.length, "Invalid listing index");
        Listing storage listing = listings[_listingIndex];
        require(listing.seller != address(0), "Listing has been removed");
        require(
            paymentToken.transferFrom(
                msg.sender,
                listing.seller,
                listing.price
            ),
            "Payment failed"
        );

        if (listing.isERC1155) {
            IERC1155 erc1155 = IERC1155(msg.sender);
            erc1155.safeTransferFrom(listing.seller, 
            msg.sender, 
            listing.tokenId, 1, ""
        );
        } else {
            IERC721 erc721 = IERC721(msg.sender);
            erc721.transferFrom(listing.seller, msg.sender, listing.tokenId);
        }

        emit NFTSold(
            listing.seller, 
            msg.sender, 
            listing.tokenId, 
            listing.price, 
            listing.isERC1155
        );
        delete listings[_listingIndex];
    }

    // Owner can remove a listing
    function removeListing(uint256 _listingIndex) public onlyOwner {
        require(_listingIndex < listings.length, "Invalid listing index");
        Listing storage listing = listings[_listingIndex];
        require(
            listing.seller != address(0), 
            "Listing has already been removed"
        );
        require(
            msg.sender == listing.seller,
            "Only the seller can remove the listing"
        );
        delete listings[_listingIndex];
    }

    // Owner can withdraw any ERC20 tokens that were sent to the contract
    function withdrawTokens(address _token, uint256 _amount) public onlyOwner {
        require(
            _token != address(paymentToken),
            "Cannot withdraw the payment token"
        );
        IERC20(_token).transfer(owner, _amount);
    }
}
