// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title IAgentRegistry
/// @notice On-chain registry for AI agent identity and capability declarations
/// @dev Every agent must register before participating in Atlas protocol.
///      Agents declare their capabilities, pricing, and execution wallet.
interface IAgentRegistry {
    // ────────────────────────────────
    //  Types
    // ────────────────────────────────

    struct AgentRecord {
        bytes32   agentId;
        address   owner;
        string    uri;                // Agent metadata endpoint
        bytes32[] capabilities;       // E.g., "TRADE", "ANALYZE", "VERIFY"
        address   executionWallet;
        uint256   minFee;             // Minimum fee per task (in ATLAS)
        bool      active;
        uint256   totalTasks;
        uint256   successfulTasks;
    }

    // ────────────────────────────────
    //  Events
    // ────────────────────────────────

    event AgentRegistered(bytes32 indexed agentId, address indexed owner, string uri);
    event AgentUpdated(bytes32 indexed agentId, string uri, bytes32[] capabilities);
    event AgentDeactivated(bytes32 indexed agentId);
    event AgentReputationUpdated(bytes32 indexed agentId, uint256 successRate);

    // ────────────────────────────────
    //  Agent Lifecycle
    // ────────────────────────────────

    /// @notice Register a new agent on the protocol
    /// @param agentId Unique identifier for the agent
    /// @param uri Metadata endpoint URI
    /// @param capabilities Array of capability identifiers
    /// @param executionWallet Address that will execute tasks
    /// @param minFee Minimum fee per task
    /// @return record The created agent record
    function register(
        bytes32   agentId,
        string    calldata uri,
        bytes32[] calldata capabilities,
        address   executionWallet,
        uint256   minFee
    ) external returns (AgentRecord memory record);

    /// @notice Update agent metadata and capabilities
    function updateAgent(
        bytes32   agentId,
        string    calldata uri,
        bytes32[] calldata newCapabilities,
        uint256   newMinFee
    ) external;

    /// @notice Deactivate an agent (permanently)
    function deactivateAgent(bytes32 agentId) external;

    /// @notice Update agent reputation score
    function updateReputation(bytes32 agentId, bool taskSuccess) external;

    // ────────────────────────────────
    //  Queries
    // ────────────────────────────────

    function getAgent(bytes32 agentId)            external view returns (AgentRecord memory);
    function getAgentByOwner(address owner)        external view returns (bytes32[] memory);
    function getAgentCount()                      external view returns (uint256);
    function searchByCapability(bytes32 capability) external view returns (bytes32[] memory);
    function isActive(bytes32 agentId)            external view returns (bool);
}
