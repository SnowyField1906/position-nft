// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Position.sol";
import "./Pool.sol";

contract PositionNFT is ERC721 {
    constructor() ERC721("PositionNFT", "PNFT") {}

    uint256 public nextTokenID = 0;
    uint256 public nextPoolID = 0;

    mapping(uint256 => bytes32) public poolIDs;
    mapping(uint256 => Position) positions;
    mapping(bytes32 => Pool) pools;


    function mint(address _owner, bytes32 _poolID, int24 _tickLower, int24 _tickUpper, uint24 _price) public {
        _mint(_owner, nextTokenID);
        positions[ nextTokenID ] = new Position(_poolID, _tickLower, _tickUpper, _price);
        nextTokenID++;
    }

    function nftInfo(uint256 _tokenID) public view returns (address, int24, int24, uint24, bytes32) {
        (bytes32 _poolID, int24 _tickLower, int24 _tickUpper, uint24 _price) = positions[ _tokenID ].positionInfo();
        return (ownerOf(_tokenID), _tickLower, _tickUpper, _price, _poolID);
    }

    function poolInfo(bytes32 _poolID) public view returns (string memory, string memory, uint24) {
        (string memory token0, string memory token1, uint24 fee) = pools[_poolID].poolInfo();
        return (token0, token1, fee);
    }

    function addPool(string memory _token0, string memory _token1, uint24 _fee) public {
        poolIDs[nextPoolID] = keccak256(abi.encodePacked(_token0, _token1, _fee));
        pools[ poolIDs[nextPoolID] ] = new Pool(_token0, _token1, _fee);
        nextPoolID++;
    }

    function availablePools() public view returns (bytes32[] memory) {
        bytes32[] memory allPools = new bytes32[](nextPoolID);
        for (uint256 i = 0; i < nextPoolID; i++) allPools[i] = poolIDs[i];
        return allPools;
    }

    function burn(uint256 _tokenId) public {
        _burn(_tokenId);
    }
}