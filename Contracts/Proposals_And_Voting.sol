// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Voting {
    enum VoteOption {
        Agree,
        Disagree,
        Abstain
    }

    // Struct to represent a proposal
    struct Proposal {
        string title;
        string description;
        uint agreeCount;
        uint disagreeCount;
        uint abstainCount;
        uint deadline;
        bool proposalPassed;
    }

    // Address of the owner
    address public owner;

    // Mapping of proposal ID to Proposal
    mapping(uint => Proposal) public proposals;

    // Mapping of voter addresses to their voted proposal ID and vote option
    mapping(address => mapping(uint => VoteOption)) public votes;

    // Total number of proposals
    uint public proposalCount;

    // Constructor to set the owner
    constructor() {
        owner = msg.sender;
    }

    // Modifier to ensure that only the owner can add proposals
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Function to add a new proposal
    function addProposal(string memory _title, string memory _description, uint _deadline) public onlyOwner {
        proposalCount++;
        proposals[proposalCount] = Proposal(_title, _description, 0, 0, 0, _deadline, false);
    }

    // Function to vote for a proposal with a specific vote option
    function vote(uint _proposalId, VoteOption _voteOption) public {
        require(_proposalId > 0 && _proposalId <= proposalCount, "Invalid proposal ID");
        require(votes[msg.sender][_proposalId] == VoteOption.Abstain, "You have already voted on this proposal");
        require(block.timestamp <= proposals[_proposalId].deadline, "Voting for this proposal has ended");

        Proposal storage proposal = proposals[_proposalId];
        
        if (_voteOption == VoteOption.Agree) {
            proposal.agreeCount++;
        } else if (_voteOption == VoteOption.Disagree) {
            proposal.disagreeCount++;
        } else if (_voteOption == VoteOption.Abstain) {
            proposal.abstainCount++;
        }

        votes[msg.sender][_proposalId] = _voteOption;
    }
    
    // Function to check if a proposal has passed
    function checkProposalResult(uint _proposalId) public view returns (bool) {
        require(_proposalId > 0 && _proposalId <= proposalCount, "Invalid proposal ID");
        Proposal storage proposal = proposals[_proposalId];
        return block.timestamp > proposal.deadline && !proposal.proposalPassed;
    }
}