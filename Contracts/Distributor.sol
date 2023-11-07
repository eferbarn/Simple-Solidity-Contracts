// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Distributor {
    address public owner;
    address public tokenAddress; // Token address (if provided)
    
    constructor(address _tokenAddress) {
        owner = msg.sender;
        tokenAddress = _tokenAddress;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
    
    function distribute(
        address[] memory _addresses, 
        uint256[] memory _shares // Better to use percents or normalized shares
    ) public payable {
        require(
            _addresses.length == _shares.length, 
            "Mismatched input arrays"
        );
        
        uint256 totalShares = 0;
        for (uint256 i = 0; i < _shares.length; i++) {
            require(_shares[i] > 0, "Share must be greater than 0");
            totalShares += _shares[i];
        }

        require(totalShares > 0, "Total shares must be greater than 0");

        if (tokenAddress != address(0)) {
            IERC20 token = IERC20(tokenAddress);
            require(
                token.balanceOf(address(this)) >= totalShares,
                "Insufficient token balance"
            );
        } else {
            require(
                address(this).balance >= totalShares,
                "Insufficient ETH balance"
            );
        }

        for (uint256 i = 0; i < _addresses.length; i++) {
            // For Every ERC20 Desired Token
            if (tokenAddress != address(0)) {
                IERC20(tokenAddress).transfer(
                    _addresses[i],
                    (_shares[i] * 10**18) / totalShares
                );
            // For Ether 
            } else {
                payable(_addresses[i]).transfer(
                    (msg.value * _shares[i]) / totalShares
                );
            }
        }
    }

    // Withdraw excess Ether (only for ETH distribution)
    function withdrawExcess() public onlyOwner {
        require(tokenAddress == address(0), "This function is for ETH distribution only");
        payable(owner).transfer(address(this).balance);
    }
    
    // Withdraw any accidentally sent tokens
    function withdrawTokens(address _token, uint256 _amount) public onlyOwner {
        require(_token != address(0), "Cannot withdraw Ether with this function");
        IERC20(_token).transfer(owner, _amount);
    }
}