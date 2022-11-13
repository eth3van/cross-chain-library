// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import {ILancaParentPool} from "../interfaces/pools/ILancaParentPool.sol";
import {LancaPoolStorage} from "./LancaPoolStorage.sol";

abstract contract LancaParentPoolStorage is LancaPoolStorage {
    /* STATE VARIABLES */

    /// @notice variable to store the maximum value that can be deposited on this pool
    uint256 public s_liquidityCap;

    /// @notice variable to store the amount temporarily used by Chainlink Functions
    uint256 public s_loansInUse;

    /// @notice variable to store the amount requested in withdrawals, incremented at startWithdrawal, decremented at completeWithdrawal
    uint256 public s_withdrawAmountLocked;

    /// @notice variable to store not processed amounts deposited by LPs
    uint256 public s_depositsOnTheWayAmount;

    /// @notice Fee amount taken from deposits
    uint256 internal s_depositFeeAmount;

    /// @notice incremented when `ccipSend` is called on child pools by CLA, decremented with each `ccipReceive`
    uint256 internal s_withdrawalsOnTheWayAmount;

    /// @notice variable to store latest index for deposit tracking
    uint8 internal s_latestDepositOnTheWayIndex;

    /* PACKED SLOT - HASHES */
    /// @notice variable to store the Chainlink Function Source Hashsum
    bytes32 internal s_getChildPoolsLiquidityJsCodeHashSum;

    /// @notice variable to store Ethers Hashsum
    bytes32 internal s_ethersHashSum;

    /* ARRAYS */

    /// @notice Storage for deposit tracking
    ILancaParentPool.DepositOnTheWay[150] internal s_depositsOnTheWayArray;

    /// @notice Array to store the withdraw requests of users
    bytes32[] public s_withdrawalRequestIds;

    /* MAPPINGS */
    /// @notice Mapping to keep track of valid pools to transfer in case of liquidation or rebalance
    mapping(uint64 chainSelector => address pool) public s_childPools;

    mapping(bytes32 clfReqId => ILancaParentPool.CLFRequestType) public s_clfRequestTypes;

    mapping(bytes32 clfReqId => ILancaParentPool.DepositRequest) public s_depositRequests;

    mapping(address lpAddress => bytes32 withdrawalId) public s_withdrawalIdByLPAddress;

    mapping(bytes32 clfReqId => bytes32 withdrawalId) public s_withdrawalIdByCLFRequestId;

    mapping(bytes32 withdrawalId => ILancaParentPool.WithdrawRequest) public s_withdrawRequests;

    /// @notice Mapping to keep track of Chainlink Functions requests
    mapping(bytes32 withdrawalId => bool isTriggered) public s_withdrawTriggered;

    /* STORAGE GAP */
    /// @notice gap to reserve storage in the contract for future variable additions
    uint256[50] private __gap;

    /* GETTERS */
    function getWithdrawalIdByLPAddress(address lpAddress) external view returns (bytes32) {
        return s_withdrawalIdByLPAddress[lpAddress];
    }

    function getUsdcInUse() external view returns (uint256) {
        return s_loansInUse;
    }

    function getWithdrawalsOnTheWayAmount() external view returns (uint256) {
        return s_withdrawalsOnTheWayAmount;
    }

    function getDepositsOnTheWay()
        external
        view
        returns (DepositOnTheWay[MAX_DEPOSITS_ON_THE_WAY_COUNT] memory)
    {
        return s_depositsOnTheWayArray;
    }

    function getPendingWithdrawalRequestIds() external view returns (bytes32[] memory) {
        return s_withdrawalRequestIds;
    }

    function getLiquidityCap() external view returns (uint256) {
        return s_liquidityCap;
    }
}
