// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ChallengeRewards
 * @dev A smart contract for distributing token rewards upon challenge completion
 */
contract ChallengeRewards {
    // ERC20 Token details
    string public name = "Challenge Reward Token";
    string public symbol = "CRT";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    
    // Challenge struct
    struct Challenge {
        uint256 id;
        string challengeName;
        string description;
        uint256 rewardAmount;
        bool isActive;
    }
    
    // ERC20 balances and allowances
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    // Mapping from challenge ID to Challenge
    mapping(uint256 => Challenge) public challenges;
    
    // Mapping to track completed challenges by user
    mapping(address => mapping(uint256 => bool)) public completedChallenges;
    
    // Authorized addresses that can validate challenge completion
    mapping(address => bool) public validators;
    
    // Challenge counter
    uint256 private _challengeCounter;
    
    // Contract owner
    address public owner;
    
    // Reentrancy guard
    bool private _locked;
    
    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event ChallengeCreated(uint256 indexed id, string challengeName, uint256 rewardAmount);
    event ChallengeCompleted(address indexed user, uint256 indexed challengeId, uint256 rewardAmount);
    event ChallengeUpdated(uint256 indexed id, string challengeName, uint256 rewardAmount, bool isActive);
    event ValidatorAdded(address indexed validator);
    event ValidatorRemoved(address indexed validator);
    
    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }
    
    modifier nonReentrant() {
        require(!_locked, "Reentrant call");
        _locked = true;
        _;
        _locked = false;
    }
    
    /**
     * @dev Constructor initializes the ERC20 token with name and symbol
     * @param initialSupply The initial token supply to mint to the contract creator
     */
    constructor(uint256 initialSupply) {
        owner = msg.sender;
        uint256 amount = initialSupply * 10**uint256(decimals);
        balanceOf[msg.sender] = amount;
        totalSupply = amount;
        emit Transfer(address(0), msg.sender, amount);
    }
    
    /**
     * @dev Transfer tokens from one address to another
     * @param to Address to transfer to
     * @param value Amount to transfer
     * @return success True if successful
     */
    function transfer(address to, uint256 value) public returns (bool success) {
        require(to != address(0), "Transfer to zero address");
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }
    
    /**
     * @dev Approve the passed address to spend the specified amount of tokens
     * @param spender The address allowed to spend tokens
     * @param value Amount of tokens allowed to spend
     * @return success True if successful
     */
    function approve(address spender, uint256 value) public returns (bool success) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
    
    /**
     * @dev Transfer tokens from one address to another with allowance
     * @param from Address to transfer from
     * @param to Address to transfer to
     * @param value Amount to transfer
     * @return success True if successful
     */
    function transferFrom(address from, address to, uint256 value) public returns (bool success) {
        require(to != address(0), "Transfer to zero address");
        require(balanceOf[from] >= value, "Insufficient balance");
        require(allowance[from][msg.sender] >= value, "Insufficient allowance");
        
        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }
    
    /**
     * @dev Add a new validator
     * @param validator Address of the validator to add
     */
    function addValidator(address validator) external onlyOwner {
        require(validator != address(0), "Invalid validator address");
        validators[validator] = true;
        emit ValidatorAdded(validator);
    }
    
    /**
     * @dev Remove a validator
     * @param validator Address of the validator to remove
     */
    function removeValidator(address validator) external onlyOwner {
        validators[validator] = false;
        emit ValidatorRemoved(validator);
    }
    
    /**
     * @dev Create a new challenge
     * @param challengeName Challenge name
     * @param description Challenge description
     * @param rewardAmount Token reward amount for completing the challenge
     */
    function createChallenge(
        string memory challengeName,
        string memory description,
        uint256 rewardAmount
    ) external onlyOwner {
        require(bytes(challengeName).length > 0, "Name cannot be empty");
        require(rewardAmount > 0, "Reward must be greater than 0");
        
        _challengeCounter++;
        uint256 challengeId = _challengeCounter;
        
        challenges[challengeId] = Challenge({
            id: challengeId,
            challengeName: challengeName,
            description: description,
            rewardAmount: rewardAmount,
            isActive: true
        });
        
        emit ChallengeCreated(challengeId, challengeName, rewardAmount);
    }
    
    /**
     * @dev Update an existing challenge
     * @param challengeId ID of the challenge to update
     * @param challengeName New challenge name
     * @param description New challenge description
     * @param rewardAmount New reward amount
     * @param isActive Whether the challenge is active
     */
    function updateChallenge(
        uint256 challengeId,
        string memory challengeName,
        string memory description,
        uint256 rewardAmount,
        bool isActive
    ) external onlyOwner {
        require(challengeId <= _challengeCounter && challengeId > 0, "Challenge does not exist");
        require(bytes(challengeName).length > 0, "Name cannot be empty");
        require(rewardAmount > 0, "Reward must be greater than 0");
        
        Challenge storage challenge = challenges[challengeId];
        challenge.challengeName = challengeName;
        challenge.description = description;
        challenge.rewardAmount = rewardAmount;
        challenge.isActive = isActive;
        
        emit ChallengeUpdated(challengeId, challengeName, rewardAmount, isActive);
    }
    
    /**
     * @dev Validate completion of a challenge and distribute rewards
     * @param user Address of the user who completed the challenge
     * @param challengeId ID of the completed challenge
     */
    function completeChallenge(address user, uint256 challengeId) external nonReentrant {
        require(validators[msg.sender] || owner == msg.sender, "Not authorized validator");
        require(user != address(0), "Invalid user address");
        require(challengeId <= _challengeCounter && challengeId > 0, "Challenge does not exist");
        require(!completedChallenges[user][challengeId], "Challenge already completed by user");
        
        Challenge storage challenge = challenges[challengeId];
        require(challenge.isActive, "Challenge is not active");
        
        // Mark challenge as completed for this user
        completedChallenges[user][challengeId] = true;
        
        // Transfer reward tokens to the user
        uint256 rewardInWei = challenge.rewardAmount * 10**uint256(decimals);
        require(balanceOf[owner] >= rewardInWei, "Owner has insufficient balance for reward");
        
        balanceOf[owner] -= rewardInWei;
        balanceOf[user] += rewardInWei;
        emit Transfer(owner, user, rewardInWei);
        
        emit ChallengeCompleted(user, challengeId, challenge.rewardAmount);
    }
    
    /**
     * @dev Get details of a challenge
     * @param challengeId ID of the challenge
     * @return Challenge details
     */
    function getChallengeDetails(uint256 challengeId) external view returns (Challenge memory) {
        require(challengeId <= _challengeCounter && challengeId > 0, "Challenge does not exist");
        return challenges[challengeId];
    }
    
    /**
     * @dev Check if a user has completed a specific challenge
     * @param user Address of the user
     * @param challengeId ID of the challenge
     * @return Boolean indicating completion status
     */
    function hasCompletedChallenge(address user, uint256 challengeId) external view returns (bool) {
        return completedChallenges[user][challengeId];
    }
    
    /**
     * @dev Get the total number of challenges
     * @return Total number of challenges created
     */
    function getTotalChallenges() external view returns (uint256) {
        return _challengeCounter;
    }
    
    /**
     * @dev Allow contract owner to withdraw tokens in case of emergency or migration
     * @param amount Amount of tokens to withdraw
     */
    function withdrawTokens(uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be greater than 0");
        require(balanceOf[address(this)] >= amount, "Insufficient balance");
        
        balanceOf[address(this)] -= amount;
        balanceOf[owner] += amount;
        emit Transfer(address(this), owner, amount);
    }
}
