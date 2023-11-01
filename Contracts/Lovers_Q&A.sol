// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract LoversMessenger {

    address public sender;
    address public receiver;
    string public currentQuestion;
    bytes32 public hashedAnswer;
    bool public questionSent;

    // Pass your partners address as an argument
    constructor(address _receiver) {
        sender = msg.sender;
        receiver = _receiver;
    }

    modifier onlySender() {
        require(
            msg.sender == sender, "Only the sender can call this function"
        );
        _;
    }

    modifier onlyReceiver() {
        require(
            msg.sender == receiver, "Only the receiver can call this function"
        );
        _;
    }

    // You will ask your question here
    function sendQuestionAndHashedAnswer(string memory question, bytes32 hashed) public onlySender {
        currentQuestion = question;
        hashedAnswer = hashed;
        questionSent = true;
    }

    // Your partner will answer it here
    function guessAnswer(bytes32 guessedHash) public onlyReceiver view returns (bool) {
        require(questionSent, "No question has been sent yet.");
        return guessedHash == hashedAnswer;
    }

    // Use this function to hash your answers and keep it secret
    function hashString(string memory input) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(input));
    }
}