// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "./Pool.sol";

contract Position {
    bytes32 poolId;
    uint256 tickLower;
    uint256 tickUpper;
    uint24 price;

    constructor(
        bytes32 _poolId,
        uint256 _tickLower,
        uint256 _tickUpper,
        uint24 _price
    ) {
        tickLower = _tickLower;
        tickUpper = _tickUpper;
        poolId = _poolId;
        price = _price;
    }

    function positionInfo() public view returns (bytes32, uint256, uint256, uint24) {
        return (poolId, tickLower, tickUpper, price);
    }
    
}