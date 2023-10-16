// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


// Interface for an off-chain identity verification service
interface IdentityVerificationService {
    address owner;

    function verifyIdentity(address user) external view returns (bool);
    function getCreditScore(address user) external view returns (uint256);
}

// Credit Score and Identity Verification Contract
contract IdentityVerification {
    IdentityVerificationService public verificationService;

    mapping(address => bool) public isVerified;
    mapping(address => uint256) public creditScores;

    event IdentityVerified(address indexed user, bool isVerified, uint256 creditScore);
    event CheckBalance(uint amount);

    //complete argument details in scripts/deploy.ts to deploy the contract with arguments

    constructor(address _verificationServiceAddress) {
        verificationService = IdentityVerificationService(_verificationServiceAddress);
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Only owner can call this function");
        _;
    }

    // Verify the identity of a user and record their credit score
    function verifyIdentityAndScore(address user) external onlyOwner {
        require(user != address(0), "Invalid address");
        require(!isVerified[user], "User is already verified");

        bool verified = verificationService.verifyIdentity(user);
        uint256 creditScore = verificationService.getCreditScore(user);

        isVerified[user] = verified;
        creditScores[user] = creditScore;

        emit IdentityVerified(user, verified, creditScore);
    }
    
    function getBalance(address user_account) external returns (uint){
       uint user_bal = user_account.balance;
       emit CheckBalance(user_bal);
       return (user_bal);
    }
}

