# Challenge Rewards Token

A blockchain-based reward system for completing challenges and earning tokens.

## Table of Contents
- [Project Title](#project-title)
- [Project Description](#project-description)
- [Project Vision](#project-vision)
- [Future Scope](#future-scope)
- [Key Features](#key-features)
- [Technical Details](#technical-details)
- [Setup and Installation](#setup-and-installation)
- [Usage](#usage)
- [License](#license)

## Project Title
**Challenge Rewards Token (CRT)** - Token rewards for completing challenges.

## Project Description
The Challenge Rewards Token (CRT) is a blockchain-based incentive system that rewards users with ERC-20 tokens for successfully completing various challenges. This smart contract allows administrators to create challenges with specific reward amounts, and authorized validators can verify challenge completion and distribute rewards accordingly.

The system provides a transparent, secure, and decentralized way to incentivize user engagement and participation in various activities, ranging from educational tasks and skill development to community contributions and promotional campaigns.

## Project Vision
Our vision is to create a flexible, scalable incentive system that can be adapted to various use cases, from educational platforms and gamified learning to community engagement and loyalty programs. By leveraging blockchain technology, we aim to provide transparent, tamper-proof reward distribution that gives users full ownership of their earned tokens.

The Challenge Rewards Token system bridges the gap between engagement and tangible rewards, creating meaningful connections between actions and incentives in a trustless environment. We believe this approach can revolutionize how organizations motivate and reward user participation.

## Future Scope
The Challenge Rewards system is designed with extensibility in mind, with planned future enhancements including:

1. **Tiered Challenge Systems**: Implementation of challenge paths with progressive difficulty and increasing rewards.
2. **NFT Integration**: Special achievements that mint unique NFTs upon completion.
3. **Time-Limited Challenges**: Challenges available only for specific time periods to drive engagement.
4. **Social Validation**: Peer-to-peer validation systems for community-driven challenge verification.
5. **Challenge Categories**: Organized challenge structures with domain-specific reward multipliers.
6. **Staking Mechanisms**: Allowing users to stake tokens to participate in premium challenges.
7. **Governance Features**: Token-based voting on new challenges and reward structures.
8. **Integration APIs**: Easy integration with external platforms and services.
9. **Automated Challenge Verification**: Oracle-based automatic verification of challenge completion criteria.
10. **Multi-chain Support**: Expanding to multiple blockchain networks.

## Key Features

### Current Features
1. **Challenge Creation and Management**
   - Create challenges with customizable names, descriptions, and reward amounts
   - Update existing challenges to adjust parameters
   - Activate/deactivate challenges as needed

2. **Reward Distribution**
   - Automatic token distribution upon validated challenge completion
   - Prevention of double rewards through completion tracking
   - Configurable reward amounts per challenge

3. **Validation System**
   - Multi-validator architecture for challenge verification
   - Flexible validator management by contract owner
   - Secure validation permissions

4. **Transparency and Security**
   - Full on-chain tracking of challenge completion
   - Event emissions for all significant actions
   - Reentrancy protection and secure token handling

5. **Administration and Control**
   - Owner-controlled challenge creation
   - Emergency funds withdrawal capability
   - Comprehensive challenge state management

## Technical Details
The Challenge Rewards Token contract is built on Solidity 0.8.20 and implements the following standards and patterns:

- **ERC-20 Token Standard**: Fully compatible token implementation
- **Ownable Pattern**: Secure administrative functions
- **ReentrancyGuard**: Protection against reentrancy attacks
- **Event Emission**: Comprehensive event logs for front-end synchronization

The contract utilizes OpenZeppelin's battle-tested libraries for maximum security and reliability.

## Setup and Installation
1. Clone the repository
2. Install dependencies:
   ```bash
   npm install @openzeppelin/contracts
   ```
3. Compile the contract:
   ```bash
   npx hardhat compile
   ```
4. Deploy to your chosen network:
   ```bash
   npx hardhat run scripts/deploy.js --network <network_name>
   ```

## Usage
### For Administrators
```javascript
// Deploy the contract with initial supply
const challengeRewards = await ChallengeRewards.deploy(1000000); // 1 million tokens

// Add a validator
await challengeRewards.addValidator("0x123...");

// Create a new challenge
await challengeRewards.createChallenge(
  "Complete 10 Coding Exercises",
  "Finish 10 coding exercises on our platform",
  100 // 100 token reward
);
```

### For Validators
```javascript
// Validate challenge completion
await challengeRewards.completeChallenge(userAddress, challengeId);
```

### For Users
Users need to:
1. Complete the specified challenge
2. Have their completion validated by an authorized validator
3. Receive tokens automatically in their wallet

## License
This project is licensed under the MIT License - see the LICENSE file for details.
