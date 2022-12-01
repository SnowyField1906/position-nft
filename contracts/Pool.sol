// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

contract Pool {
    struct PoolInfo {
        string token0;
        string token1;
        uint24 fee;
    }

    mapping(string => PoolInfo) public pools;

    function addPool(string memory token0, string memory token1, uint24 fee) public {
        pools[getPoolId(token0, token1, fee)] = PoolInfo(token0, token1, fee);
    }

    function getPoolInfo(string memory _poolId) public view returns (string memory, string memory, uint24) {
        return (pools[_poolId].token0, pools[_poolId].token1, pools[_poolId].fee);
    }

    function getPoolId(string memory token0, string memory token1, uint24 fee) public pure returns (string memory) {
        return string(abi.encodePacked(token0, "-", token1, "-", string(abi.encodePacked(fee)), "/"));
    }
}