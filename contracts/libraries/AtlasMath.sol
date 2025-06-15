// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title AtlasMath
/// @notice Shared math utilities for the Atlas protocol
library AtlasMath {
    // ────────────────────────────────
    //  Constants
    // ────────────────────────────────

    uint256 public constant BPS_DENOMINATOR = 10_000;
    uint256 public constant MAX_FEE_BPS     = 5_000; // 50%
    uint256 public constant MIN_LOCK_PERIOD = 1 days;
    uint256 public constant MAX_LOCK_PERIOD = 365 days;

    // ────────────────────────────────
    //  Fee Calculations
    // ────────────────────────────────

    /// @notice Calculate performance fee for a given profit
    function calculateFee(uint256 profit, uint256 feeBps) internal pure returns (uint256) {
        require(feeBps <= MAX_FEE_BPS, "AtlasMath: fee too high");
        return (profit * feeBps) / BPS_DENOMINATOR;
    }

    /// @notice Calculate guardian reward for a task
    function calculateGuardianReward(uint256 taskValue, uint256 rewardBps) internal pure returns (uint256) {
        return (taskValue * rewardBps) / BPS_DENOMINATOR;
    }

    /// @notice Calculate slashing amount
    function calculateSlash(uint256 stakedAmount, uint256 slashBps) internal pure returns (uint256) {
        require(slashBps <= BPS_DENOMINATOR, "AtlasMath: invalid slash");
        return (stakedAmount * slashBps) / BPS_DENOMINATOR;
    }

    // ────────────────────────────────
    //  Validation
    // ────────────────────────────────

    /// @notice Validate lock period is within allowed range
    function validateLockPeriod(uint256 lockPeriod) internal pure returns (bool) {
        return lockPeriod >= MIN_LOCK_PERIOD && lockPeriod <= MAX_LOCK_PERIOD;
    }

    /// @notice Validate ecosystem identifier
    function isValidEcosystem(bytes32 ecosystem) internal pure returns (bool) {
        return ecosystem == keccak256("robinhood-chain")
            || ecosystem == keccak256("evm")
            || ecosystem == keccak256("virtuals");
    }

    // ────────────────────────────────
    //  Token Amounts
    // ────────────────────────────────

    /// @notice Convert ATLAS to wei-like unit (18 decimals)
    function toAtlas(uint256 amount) internal pure returns (uint256) {
        return amount * 1e18;
    }
}
