// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StorylineProgress {
    address public owner;
    uint256 public chapterCount;

    struct UserProgress {
        uint256 unlockedChapters;
        uint256 rewardTokens;
    }

    mapping(address => UserProgress) public progress;

    event ChapterUnlocked(address indexed user, uint256 chapter);
    event RewardClaimed(address indexed user, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    constructor(uint256 _chapterCount) {
        owner = msg.sender;
        chapterCount = _chapterCount;
    }

    function unlockChapter(address user, uint256 chapter) external onlyOwner {
        require(chapter > 0 && chapter <= chapterCount, "Invalid chapter");
        require(progress[user].unlockedChapters < chapter, "Chapter already unlocked");

        progress[user].unlockedChapters = chapter;
        progress[user].rewardTokens += 10; // Example: 10 tokens per chapter
        emit ChapterUnlocked(user, chapter);
    }

    function claimReward() external {
        uint256 reward = progress[msg.sender].rewardTokens;
        require(reward > 0, "No rewards to claim");

        progress[msg.sender].rewardTokens = 0;
        payable(msg.sender).transfer(reward);
        emit RewardClaimed(msg.sender, reward);
    }

    receive() external payable {} // Allow the contract to receive ETH
}
