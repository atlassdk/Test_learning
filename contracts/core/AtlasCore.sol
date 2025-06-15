// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IAtlasCore} from "../interfaces/IAtlasCore.sol";
import {IAgentRegistry} from "../interfaces/IAgentRegistry.sol";
import {ITaskManager} from "../interfaces/ITaskManager.sol";
import {ISettlementEngine} from "../interfaces/ISettlementEngine.sol";
import {IAtlasBridge} from "../interfaces/IAtlasBridge.sol";

/// @title AtlasCore
/// @notice Core protocol contract — entry point for all Atlas operations
/// @dev This is the main contract that coordinates agent registration, task
///      lifecycle, cross-ecosystem messaging, and economic settlement across
///      Robinhood Chain, EVM ecosystems, and Virtuals Protocol.
contract AtlasCore is IAtlasCore {
    // ────────────────────────────────
    //  State
    // ────────────────────────────────

    /// @dev Protocol version tracking
    bytes32 public constant override VERSION = keccak256("atlas-core-v0.1.3");

    /// @dev Supported ecosystems
    bytes32 public constant override ECOSYSTEM_ROBINHOOD = keccak256("robinhood-chain");
    bytes32 public constant override ECOSYSTEM_EVM       = keccak256("evm");
    bytes32 public constant override ECOSYSTEM_VIRTUALS   = keccak256("virtuals");

    /// @dev Guardian configuration
    uint256 public constant override MIN_GUARDIAN_STAKE = 10_000 ether;
    uint256 public constant override GUARDIAN_COMMITTEE_SIZE = 5;
    uint256 public constant override SLASH_PERCENTAGE = 5_000; // 50% in bps

    IAgentRegistry    public immutable agentRegistry;
    ITaskManager      public immutable taskManager;
    ISettlementEngine public immutable settlementEngine;
    IAtlasBridge      public immutable bridge;

    mapping(address => GuardianInfo) public guardians;
    address[] public guardianList;

    uint256 public override protocolVersion;
    bool    public override paused;

    // ────────────────────────────────
    //  Constructor
    // ────────────────────────────────

    constructor(
        address _agentRegistry,
        address _taskManager,
        address _settlementEngine,
        address _bridge
    ) {
        agentRegistry    = IAgentRegistry(_agentRegistry);
        taskManager      = ITaskManager(_taskManager);
        settlementEngine = ISettlementEngine(_settlementEngine);
        bridge           = IAtlasBridge(_bridge);
        protocolVersion  = 1;
    }

    // ────────────────────────────────
    //  Guardian Management
    // ────────────────────────────────

    /// @inheritdoc IAtlasCore
    function registerGuardian(uint256 stakeAmount) external override {
        require(!paused, "AtlasCore: paused");
        require(stakeAmount >= MIN_GUARDIAN_STAKE, "AtlasCore: insufficient stake");
        require(guardians[msg.sender].stake == 0, "AtlasCore: already guardian");

        guardians[msg.sender] = GuardianInfo({
            staker: msg.sender,
            stake: stakeAmount,
            active: true,
            tasksVerified: 0,
            tasksSlashed: 0
        });
        guardianList.push(msg.sender);
        emit GuardianRegistered(msg.sender, stakeAmount);
    }

    /// @inheritdoc IAtlasCore
    function slashGuardian(address guardian, uint256 amount) external override {
        // Only callable by governance or dispute resolution
        require(guardians[guardian].stake >= amount, "AtlasCore: insufficient stake");
        guardians[guardian].stake -= amount;
        guardians[guardian].tasksSlashed++;
        emit GuardianSlashed(guardian, amount);
    }

    // ────────────────────────────────
    //  Protocol Management
    // ────────────────────────────────

    /// @inheritdoc IAtlasCore
    function pause() external override {
        paused = true;
        emit ProtocolPaused(msg.sender);
    }

    /// @inheritdoc IAtlasCore
    function unpause() external override {
        paused = false;
        emit ProtocolUnpaused(msg.sender);
    }

    /// @inheritdoc IAtlasCore
    function getGuardianCount() external view override returns (uint256) {
        return guardianList.length;
    }
}
