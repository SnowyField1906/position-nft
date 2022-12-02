// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

contract Pool {
    string token0;
    string token1;
    uint24 fee;

    constructor(string memory _token0, string memory _token1, uint24 _fee) {
        token0 = _token0;
        token1 = _token1;
        fee = _fee;
    }

    function poolInfo() public view returns (string memory, string memory, uint24) {
        return (token0, token1, fee);
    }
}