// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title IAtlasBridge
/// @notice Cross-ecosystem message passing between Robinhood Chain, EVM, and Virtuals
interface IAtlasBridge {
    struct CrossChainMessage {
        bytes32 messageId;
        bytes32 sourceEcosystem;
        bytes32 targetEcosystem;
        bytes   payload;
        address sender;
        bool    delivered;
    }

    event MessageSent(bytes32 indexed messageId, bytes32 targetEcosystem, address indexed sender);
    event MessageDelivered(bytes32 indexed messageId, bytes32 sourceEcosystem);
    event MessageFailed(bytes32 indexed messageId, bytes reason);
    event GuardianVerification(bytes32 indexed messageId, address indexed guardian, bool valid);

    function sendMessage(
        bytes32 targetEcosystem,
        bytes   calldata payload
    ) external returns (bytes32 messageId);

    function deliverMessage(
        bytes32 messageId,
        bytes   calldata payload,
        bytes   calldata proof
    ) external returns (bool);

    function verifyMessage(
        bytes32 messageId,
        bool    valid
    ) external;

    function getMessage(bytes32 messageId) external view returns (CrossChainMessage memory);
}
