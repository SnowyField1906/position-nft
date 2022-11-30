// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

contract Position {
    address pool;
    address owner;
    int24 tickLower;
    int24 tickUpper;
    uint24 fee;

    constructor(
        address _pool,
        address _owner,
        int24 _tickLower,
        int24 _tickUpper,
        uint24 _fee
    ) {
        pool = _pool;
        owner = _owner;
        tickLower = _tickLower;
        tickUpper = _tickUpper;
        fee = _fee;
    }

    function info() public view returns (address, address, int24, int24, uint24) {
        return (pool, owner, tickLower, tickUpper, fee);
    }

}