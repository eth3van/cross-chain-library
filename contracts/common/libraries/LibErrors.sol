// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

library LibErrors {
    enum InvalidAddressType {
        zeroAddress,
        notMessenger,
        unsupportedCcipToken,
        notOwner,
        notUsdcToken,
        unauthorized,
        sameAddress
    }

    enum UnauthorizedType {
        notLancaBridge
    }

    /// @dev Reverts when the address is invalid.
    error InvalidAddress(InvalidAddressType errorType);

    error Unauthorized(UnauthorizedType errorType);
}
