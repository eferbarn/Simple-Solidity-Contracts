// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract RandomNumberGenerator {
    address public owner;
    uint256 public randomResult;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function getRandomNumber(
        uint256 seed,
        uint256 lower,
        uint256 upper
    ) public onlyOwner {
        require(lower < upper, "Lower bound must be less than upper bound");

        uint256 randomness = uint256(
            keccak256(
                abi.encodePacked(
                    block.timestamp,
                    msg.sender,
                    seed)
        ));
        uint256 randomNumber = (randomness % (upper - lower + 1)) + lower;

        randomResult = randomNumber;
    }
}
