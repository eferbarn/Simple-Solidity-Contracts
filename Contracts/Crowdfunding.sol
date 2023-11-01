// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Import the ERC20 interface for USDT
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Crowdfunding {
    address public owner;
    uint256 public fundingGoal;
    uint256 public totalFunding;
    IERC20 public usdt; // USDT token contract address

    mapping(address => uint256) public contributions;
    bool public isFundingClosed;

    event FundingReceived(address indexed contributor, uint256 amount);

    constructor(address _usdt, uint256 _goal) {
        owner = msg.sender;
        usdt = IERC20(_usdt);
        fundingGoal = _goal;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function contribute(uint256 amount) public {
        require(!isFundingClosed, "Funding is closed");
        require(amount > 0, "Contribution must be greater than 0");

        uint256 allowance = usdt.allowance(msg.sender, address(this));
        require(allowance >= amount, "Not enough allowance to transfer USDT");

        bool success = usdt.transferFrom(msg.sender, address(this), amount);
        require(success, "USDT transfer failed");

        contributions[msg.sender] += amount;
        totalFunding += amount;
        emit FundingReceived(msg.sender, amount);

        if (totalFunding >= fundingGoal) {
            isFundingClosed = true;
        }
    }

    function closeFunding() public onlyOwner {
        require(isFundingClosed, "Funding is not closed yet");

        // Implement logic for transferring funds to the project owner or beneficiary.
        // For simplicity, let's assume the owner can withdraw the funds.
        bool success = usdt.transfer(owner, totalFunding);
        require(success, "USDT transfer to the owner failed");
    }
}