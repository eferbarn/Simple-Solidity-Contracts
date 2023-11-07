// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract EternalArtGallery {
    struct Artwork {
        address artist;
        string title;
        string description;
        string imageURL;
        uint256 price;
    }

    Artwork[] public artworks;
    mapping(uint256 => address) public artworkToOwner;
    mapping(address => uint256[]) public artistArtworks;
    mapping(uint256 => uint256) public artworkToRoyalties;
    address public owner;

    event ArtworkCreated(
        uint256 artworkId, address artist, string title, uint256 price
    );
    event ArtworkPurchased(
        uint256 artworkId, address buyer, address seller, uint256 price
    );

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function createArtwork(
        string memory _title, string memory _description, string memory _imageURL, uint256 _price
    ) public {
        require(_price > 0, "Artwork price must be greater than 0");
        Artwork memory newArtwork = Artwork(
            msg.sender, _title, _description, _imageURL, _price
        );
        uint256 artworkId = artworks.push(newArtwork) - 1;
        artworkToOwner[artworkId] = msg.sender;
        artistArtworks[msg.sender].push(artworkId);
        artworkToRoyalties[artworkId] = 0;
        emit ArtworkCreated(artworkId, msg.sender, _title, _price);
    }

    function purchaseArtwork(uint256 _artworkId) public payable {
        require(_artworkId < artworks.length, "Artwork ID does not exist");
        Artwork storage artwork = artworks[_artworkId];
        require(
            msg.value >= artwork.price, 
            "Insufficient funds to purchase artwork"
        );

        address seller = artwork.artist;
        address buyer = msg.sender;
        uint256 purchasePrice = artwork.price;
        uint256 royalties = (purchasePrice * 10) / 100; // 10% royalties to the artist

        artworkToOwner[_artworkId] = buyer;
        artistArtworks[seller].push(_artworkId);
        artworkToRoyalties[_artworkId] += royalties;

        (bool success, ) = payable(seller).call{
            value: purchasePrice - royalties
        }("");
        require(success, "Transfer to the seller failed");

        emit ArtworkPurchased(_artworkId, buyer, seller, purchasePrice);
    }

    function withdrawRoyalties(uint256 _artworkId) public {
        uint256 royalties = artworkToRoyalties[_artworkId];
        require(royalties > 0, "No royalties available for withdrawal");
        artworkToRoyalties[_artworkId] = 0;
        (bool success, ) = payable(msg.sender).call{value: royalties}("");
        require(success, "Royalty withdrawal failed");
    }

    function getArtworkCount() public view returns (uint256) {
        return artworks.length;
    }

    function getArtworkByIndex(uint256 _index) public view returns (Artwork memory) {
        require(_index < artworks.length, "Index out of range");
        return artworks[_index];
    }
}
