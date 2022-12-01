// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "./Pool.sol";

contract Position is Pool {
    int24 tickLower;
    int24 tickUpper;
    string poolId;

    constructor(
        int24 _tickLower,
        int24 _tickUpper,
        string memory _token0,
        string memory _token1,
        uint24 _fee
    ) {
        tickLower = _tickLower;
        tickUpper = _tickUpper;
        poolId = string(abi.encodePacked(_token0, "-", _token1, "-", string(abi.encodePacked(_fee)), "/"));
        addPool(_token0, _token1, _fee);
    }

    function positionInfo() public view returns (int24, int24) {
        return (tickLower, tickUpper);
    }

    function getPoolId() public view returns (string memory) {
        return poolId;
    }

    function getPoolInfo() public view returns (string memory, string memory, uint24) {
        return (pools[poolId].token0, pools[poolId].token1, pools[poolId].fee);
    }
    
}