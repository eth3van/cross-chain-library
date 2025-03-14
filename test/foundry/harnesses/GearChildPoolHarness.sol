// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import {LancaChildPool} from "contracts/pools/LancaChildPool.sol";

contract LancaChildPoolHarness is LancaChildPool {
    constructor(
        address link,
        address owner,
        address ccipRouter,
        address usdc,
        address lancaBridge,
        address[3] memory messengers
    ) LancaChildPool(link, owner, ccipRouter, usdc, lancaBridge, messengers) {}

    function exposed_getDstPoolByChainSelector(
        uint64 chainSelector
    ) external view returns (address) {
        return s_dstPoolByChainSelector[chainSelector];
    }

    function exposed_getPoolChainSelectors() external view returns (uint64[] memory) {
        return s_poolChainSelectors;
    }

    function exposed_getMessengers() external view returns (address[3] memory) {
        address[3] memory messengers = [i_messenger0, i_messenger1, i_messenger2];
        return messengers;
    }

    function exposed_getDistributeLiquidityRequestProcessed(
        bytes32 distributeLiquidityRequestId
    ) external view returns (bool) {
        return s_distributeLiquidityRequestProcessed[distributeLiquidityRequestId];
    }

    function exposed_getLinkToken() external view returns (address) {
        return address(i_linkToken);
    }

    function exposed_getUsdcToken() external view returns (address) {
        return address(i_usdc);
    }

    function exposed_getLancaBridge() external view returns (address) {
        return address(i_lancaBridge);
    }

    function exposed_getLoansInUse() external view returns (uint256) {
        return s_loansInUse;
    }

    function exposed_setDstPoolByChainSelector(uint64 chainSelector, address pool) external {
        s_dstPoolByChainSelector[chainSelector] = pool;
    }

    function exposed_setIsWithdrawalRequestTriggered(
        bytes32 withdrawalId,
        bool isTriggered
    ) external {
        s_isWithdrawalRequestTriggered[withdrawalId] = isTriggered;
    }

    function exposed_setDistributeLiquidityRequestProcessed(
        bytes32 distributeLiquidityRequestId,
        bool processed
    ) external {
        s_distributeLiquidityRequestProcessed[distributeLiquidityRequestId] = processed;
    }
}
