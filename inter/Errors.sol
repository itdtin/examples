// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

library Errors {
    //Common
    error Expired();
    error InvalidSignature(address recoveredAddress);
    error WrongLength();
    error WrongArguments();
    error TransferFailed();
    error Reentrant();
    error ZeroAddress();
    error ZeroAmount();
    error NotEnoughValue();
    error AmountError(bytes msg, uint256 amount);

    //Pools
    error NoPool();
    error DuplicatePool();
    error DuplicateTokens();
    error InvalidPoolParams();
    error MinTokens();
    error MaxTokens();
    error InvalidPoolId();
    error UnExistedToken();
    error FeeError(bytes msg, uint256 amount);

    //Gas ad slippage
    error TooMuchSlippage();
    error GasIsOver();

    //Payload
    error NotStoredPayload();
    error InvalidPayload();
    error InvalidMethod(uint8 method);

    // Access Control
    error AccessError(bytes errorMsg);

    // Blacklist
    error TokenInBlacklist();
    error IdenticalAddresses();

    // Math
    error OutOfBounds();
    error InvalidExponent();
    error MaxInRatio();
    error InvalidInvariantRatio();
    error StableGetBalanceDidntConverge();
    error StableInvariantDidntConverge();

    //Fees
    error TooBigFee();
    error InvalidFee();

    //Integrations
    error InvalidSrcToken();
    error InvalidDestToken();
    error InvalidPath();

    //Staking
    error InvalidStartBlock();
    error InvalidBonusEndBlock();
    error PoolExist();
    error InvalidMultiplier();

    //Sale
    error NotStarted();
    error NotFinished();
    error Started();
    error HardcapReached();
}
