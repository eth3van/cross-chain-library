// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import {ILancaBridgeStorage} from "../interfaces/ILancaBridgeStorage.sol";

abstract contract LancaBridgeStorage {
    /// @notice Variable to store the Link to USDC latest rate
    uint256 internal s_latestLinkUsdcRate;

    mapping(uint64 chainSelector => address lancaBridge) internal s_lancaBridgeContractsByChain;
    mapping(uint64 dstChainSelector => bytes32[] bridgeTxIds)
        internal s_pendingSettlementIdsByDstChain;
    mapping(bytes32 conceroMessageId => PendingSettlementTx tx) internal s_pendingSettlementTxById;
    mapping(uint64 dstChainSelector => uint256 amount)
        internal s_pendingSettlementTxAmountByDstChain;
    mapping(uint64 dstChainSelector => uint256 lastCcipFeeInLink) internal s_lastCcipFeeInLink;
    mapping(address sender => bool isAllowed) internal s_isConceroMessageSenderAllowed;
    mapping(uint64 srcChainSelector => bool isAllowed) internal s_isConceroMessageSrcChainAllowed;
    mapping(address sender => bool isAllowed) internal s_isCcipMessageSenderAllowed;
    mapping(uint64 srcChainSelector => bool isAllowed) internal s_isCcipMessageSrcChainAllowed;
    mapping(bytes32 txId => bool isConfirmed) internal s_isBridgeProcessed;

    /* GETTERS */
    function getPendingSettlementIdsByDstChain(
        uint64 dstChainSelector
    ) external view returns (bytes32[] memory) {
        return s_pendingSettlementIdsByDstChain[dstChainSelector];
    }

    function getPendingSettlementTxById(
        bytes32 conceroMessageId
    ) external view returns (PendingSettlementTx memory) {
        return s_pendingSettlementTxById[conceroMessageId];
    }

    function getPendingSettlementTxAmountByDstChain(
        uint64 dstChainSelector
    ) external view returns (uint256) {
        return s_pendingSettlementTxAmountByDstChain[dstChainSelector];
    }

    function isConceroMessageSenderAllowed(address sender) external view returns (bool) {
        return s_isConceroMessageSenderAllowed[sender];
    }

    function isConceroMessageSrcChainAllowed(uint64 srcChainSelector) external view returns (bool) {
        return s_isConceroMessageSrcChainAllowed[srcChainSelector];
    }
}
