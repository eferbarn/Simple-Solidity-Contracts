// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract RandomNumberGenerator {
    address public owner;
    uint256 public revealEndTime;
    uint256 public randomSeed;
    bool public revealed;
    uint256 public randomResult;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function commit(
        uint256 seed,
        uint8 endTimeHours
    ) public onlyOwner {
        require(!revealed, "Commit phase is over.");
        randomSeed = seed;
        revealed = false;
        // Set the reveal phase end time, e.g., 24 hours from now
        revealEndTime = block.timestamp + endTimeHours * 86400 ;
    }

    function reveal(
        uint256 seed,
        uint256 lower,
        uint256 upper
    ) public onlyOwner {
        require(!revealed, "Reveal phase is over.");
        require(block.timestamp <= revealEndTime, "Reveal phase has ended.");
        require(randomSeed == seed, "Revealed seed does not match the committed seed.");

        uint256 randomness = uint256(keccak256(
            abi.encodePacked(
                block.timestamp,
                msg.sender,
                seed
            )
        ));
        uint256 randomNumber = (randomness % (upper - lower + 1)) + lower;

        randomResult = randomNumber;
        revealed = true;
    }

    function setRevealedStatus(bool status) public onlyOwner {
        revealed = status;
    }

    function getRevealedStatus() public view returns (bool) {
        return revealed;
    }
}