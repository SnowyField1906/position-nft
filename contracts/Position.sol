// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "./Pool.sol";

contract Position {
    bytes32 poolId;
    int24 tickLower;
    int24 tickUpper;
    uint24 amount;

    constructor(
        bytes32 _poolId,
        int24 _tickLower,
        int24 _tickUpper,
        uint24 _amount
    ) {
        tickLower = _tickLower;
        tickUpper = _tickUpper;
        poolId = _poolId;
        amount = _amount;
    }

    function positionInfo() public view returns (bytes32, int24, int24, uint24) {
        return (poolId, tickLower, tickUpper, amount);
    }
    
}