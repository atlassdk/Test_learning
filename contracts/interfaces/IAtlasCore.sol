// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title IAtlasCore
/// @notice Core protocol interface for the Atlas Agent Coordination Layer
/// @dev All Atlas protocol entry points converge through this interface
interface IAtlasCore {
    // ────────────────────────────────
    //  Types
    // ────────────────────────────────

    struct GuardianInfo {
        address staker;
        uint256 stake;
        bool    active;
        uint256 tasksVerified;
        uint256 tasksSlashed;
    }

    // ────────────────────────────────
    //  Events
    // ────────────────────────────────

    event GuardianRegistered(address indexed guardian, uint256 stake);
    event GuardianSlashed(address indexed guardian, uint256 amount);
    event GuardianRewarded(address indexed guardian, uint256 amount);
    event ProtocolPaused(address indexed pauser);
    event ProtocolUnpaused(address indexed pauser);

    // ────────────────────────────────
    //  Constants
    // ────────────────────────────────

    function VERSION()                       external view returns (bytes32);
    function ECOSYSTEM_ROBINHOOD()           external view returns (bytes32);
    function ECOSYSTEM_EVM()                 external view returns (bytes32);
    function ECOSYSTEM_VIRTUALS()            external view returns (bytes32);
    function MIN_GUARDIAN_STAKE()            external view returns (uint256);
    function GUARDIAN_COMMITTEE_SIZE()       external view returns (uint256);
    function SLASH_PERCENTAGE()              external view returns (uint256);

    // ────────────────────────────────
    //  Guardian Operations
    // ────────────────────────────────

    /// @notice Register as a protocol guardian by staking ATLAS tokens
    /// @param stakeAmount Amount of ATLAS to stake (must exceed MIN_GUARDIAN_STAKE)
    function registerGuardian(uint256 stakeAmount) external;

    /// @notice Slash a guardian's stake (governance only)
    /// @param guardian Address of the guardian to slash
    /// @param amount Amount of ATLAS to slash
    function slashGuardian(address guardian, uint256 amount) external;

    // ────────────────────────────────
    //  Protocol Management
    // ────────────────────────────────

    function pause()   external;
    function unpause() external;
    function paused()  external view returns (bool);

    // ────────────────────────────────
    //  Queries
    // ────────────────────────────────

    function protocolVersion()      external view returns (uint256);
    function getGuardianCount()     external view returns (uint256);
    function guardians(address)     external view returns (GuardianInfo memory);
}
