// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title ITaskManager
/// @notice Manages the lifecycle of agent tasks: creation, bidding, execution, settlement
interface ITaskManager {
    // ────────────────────────────────
    //  Types
    // ────────────────────────────────

    enum TaskStatus { Pending, Bidding, Executing, Verifying, Completed, Failed, Disputed }
    enum BidStatus  { Pending, Accepted, Rejected }

    struct Task {
        bytes32   taskId;
        address   creator;
        bytes32[] requiredCapabilities;
        uint256   budget;        // In ATLAS tokens
        bytes     parameters;
        TaskStatus status;
        address   assignedAgent;
        uint256   createdAt;
        uint256   deadline;
    }

    struct Bid {
        address bidder;
        uint256 fee;
        BidStatus status;
    }

    // ────────────────────────────────
    //  Events
    // ────────────────────────────────

    event TaskCreated(bytes32 indexed taskId, address indexed creator, uint256 budget);
    event BidSubmitted(bytes32 indexed taskId, address indexed bidder, uint256 fee);
    event BidAccepted(bytes32 indexed taskId, address indexed agent);
    event TaskCompleted(bytes32 indexed taskId, bytes result);
    event TaskVerified(bytes32 indexed taskId, address indexed verifier);
    event TaskDisputed(bytes32 indexed taskId, address indexed disputer);

    // ────────────────────────────────
    //  Task Lifecycle
    // ────────────────────────────────

    function createTask(
        bytes32   taskId,
        bytes32[] calldata requiredCapabilities,
        uint256   budget,
        bytes     calldata parameters,
        uint256   deadline
    ) external returns (Task memory task);

    function submitBid(bytes32 taskId, uint256 fee) external;
    function acceptBid(bytes32 taskId, address agent) external;
    function completeTask(bytes32 taskId, bytes calldata result, bytes calldata proof) external;
    function verifyTask(bytes32 taskId, bool valid) external;
    function disputeTask(bytes32 taskId, bytes calldata evidence) external;
    function settleTask(bytes32 taskId) external;

    function getTask(bytes32 taskId)    external view returns (Task memory);
    function getBids(bytes32 taskId)    external view returns (Bid[] memory);
    function getTaskCount()             external view returns (uint256);
}
