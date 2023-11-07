// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract NFTMarketplace {
    address public owner;

    // Royalty percentage for the marketplace (0-100)
    uint256 public marketplaceRoyaltyPercentage;

    struct Listing {
        address seller;
        uint256 tokenId;
        uint256 price;
        address paymentToken;
        bool isERC1155;
        address artist;
        uint256 artistRoyalty; // Royalty percentage for the artist (0-100)
    }

    Listing[] public listings;
    mapping(address => bool) public supportedTokens;

    event NFTListed(address indexed seller, uint256 indexed tokenId, uint256 price, address indexed paymentToken, bool isERC1155, address artist, uint256 artistRoyalty);
    event NFTSold(address indexed seller, address indexed buyer, uint256 indexed tokenId, uint256 price, bool isERC1155);

    constructor(uint256 _marketplaceRoyaltyPercentage) {
        owner = msg.sender;
        require(_marketplaceRoyaltyPercentage >= 0 && _marketplaceRoyaltyPercentage <= 100, "Invalid marketplace royalty percentage");
        marketplaceRoyaltyPercentage = _marketplaceRoyaltyPercentage;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function listNFT(uint256 _tokenId, uint256 _price, address _paymentToken, bool _isERC1155, address _artist, uint256 _artistRoyalty) public {
        require(_price > 0, "Price must be greater than 0");
        require(_artist != address(0), "Invalid artist address");
        require(
            _artistRoyalty >= 0 && _artistRoyalty <= 100, 
            "Invalid artist royalty percentage"
        );
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

        require(
            supportedTokens[_paymentToken], "Payment token is not supported"
        );

        listings.push(Listing({
            seller: msg.sender,
            tokenId: _tokenId,
            price: _price,
            paymentToken: _paymentToken,
            isERC1155: _isERC1155,
            artist: _artist,
            artistRoyalty: _artistRoyalty
        }));

        emit NFTListed(
            msg.sender, 
            _tokenId, _price, 
            _paymentToken, 
            _isERC1155, _artist, 
            _artistRoyalty
        );
    }

    function buyNFT(uint256 _listingIndex) public {
        require(_listingIndex < listings.length, "Invalid listing index");
        Listing storage listing = listings[_listingIndex];
        require(listing.seller != address(0), "Listing has been removed");
        require(
            listing.paymentToken == msg.sender, 
            "Payment token not supported for this listing"
        );
        require(
            IERC20(listing.paymentToken).transferFrom(msg.sender, 
            listing.seller, listing.price),
            "Payment failed"
        );

        if (listing.isERC1155) {
            IERC1155 erc1155 = IERC1155(msg.sender);
            erc1155.safeTransferFrom(
                listing.seller, 
                msg.sender, 
                listing.tokenId, 
                1, 
                ""
            );
        } else {
            IERC721 erc721 = IERC721(msg.sender);
            erc721.transferFrom(listing.seller, msg.sender, listing.tokenId);
        }

        // Calculate and transfer royalties
        uint256 artistRoyaltyAmount = (
            listing.price * listing.artistRoyalty
        ) / 100;
        uint256 marketplaceRoyaltyAmount = (
            listing.price * marketplaceRoyaltyPercentage
        ) / 100;

        IERC20(listing.paymentToken).transfer(
            listing.artist, artistRoyaltyAmount
        );
        IERC20(listing.paymentToken).transfer(
            owner, marketplaceRoyaltyAmount
        );

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

    // Owner can add or remove supported payment tokens
    function toggleSupportedToken(address _paymentToken, bool _isSupported) public onlyOwner {
        supportedTokens[_paymentToken] = _isSupported;
    }

    // Owner can withdraw any ERC20 tokens that were sent to the contract
    function withdrawTokens(address _token, uint256 _amount) public onlyOwner {
        require(
            // address(0) represents Ether
            _token != address(0), 
            "Cannot withdraw Ether with this function"
        );
        IERC20(_token).transfer(owner, _amount);
    }
}
