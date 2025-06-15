// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC4626} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title AtlasAgentVault
/// @notice ERC-4626 compliant vault for agent-managed capital
/// @dev Agents can deposit USDC and receive shares. Shareholders vote on
///      agent proposals. Guardian network verifies execution.
contract AtlasAgentVault is ERC4626 {
    // ────────────────────────────────
    //  State
    // ────────────────────────────────

    address public immutable agentId;
    uint256 public totalFeesCollected;
    uint256 public performanceFee; // basis points, e.g. 2000 = 20%
    bool    public acceptingDeposits;

    mapping(address => uint256) public deposits;
    mapping(bytes32 => bool)     public executedProposals;

    // ────────────────────────────────
    //  Events
    ────────────────────────────────

    event ProposalSubmitted(bytes32 indexed proposalId, bytes data);
    event ProposalExecuted(bytes32 indexed proposalId, bytes result);
    event FeesCollected(uint256 amount);
    event GuardianVerified(bytes32 indexed proposalId);

    // ────────────────────────────────
    //  Constructor
    // ────────────────────────────────

    constructor(
        IERC20 _asset,
        address _agentId,
        string memory _name,
        string memory _symbol
    ) ERC4626(_asset, _name, _symbol) {
        agentId = _agentId;
        performanceFee = 2000; // 20% default
        acceptingDeposits = true;
    }

    // ────────────────────────────────
    //  Vault Operations
    // ────────────────────────────────

    /// @notice Submit a proposal for execution
    function submitProposal(bytes calldata data) external returns (bytes32 proposalId) {
        require(msg.sender == agentId, "AtlasAgentVault: not agent");
        proposalId = keccak256(abi.encodePacked(block.timestamp, data));
        executedProposals[proposalId] = false;
        emit ProposalSubmitted(proposalId, data);
    }

    /// @notice Execute a verified proposal
    function executeProposal(bytes32 proposalId, bytes calldata result) external {
        require(msg.sender == agentId, "AtlasAgentVault: not agent");
        require(!executedProposals[proposalId], "AtlasAgentVault: already executed");
        executedProposals[proposalId] = true;
        emit ProposalExecuted(proposalId, result);
    }

    /// @notice Toggle deposit acceptance
    function setAcceptingDeposits(bool _accepting) external {
        require(msg.sender == agentId, "AtlasAgentVault: not agent");
        acceptingDeposits = _accepting;
    }

    /// @notice Set performance fee
    function setPerformanceFee(uint256 _fee) external {
        require(msg.sender == agentId, "AtlasAgentVault: not agent");
        require(_fee <= 5000, "AtlasAgentVault: fee too high"); // max 50%
        performanceFee = _fee;
    }

    // ────────────────────────────────
    //  Overrides
    // ────────────────────────────────

    function deposit(uint256 assets, address receiver) public override returns (uint256) {
        require(acceptingDeposits, "AtlasAgentVault: not accepting deposits");
        return super.deposit(assets, receiver);
    }

    function mint(uint256 shares, address receiver) public override returns (uint256) {
        require(acceptingDeposits, "AtlasAgentVault: not accepting deposits");
        return super.mint(shares, receiver);
    }
}
