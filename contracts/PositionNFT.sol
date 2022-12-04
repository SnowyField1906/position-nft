// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./Position.sol";
import "./Pool.sol";

contract PositionNFT is ERC721URIStorage {
    constructor () ERC721("PositionNFT", "PNFT") {}

    uint256 public nextTokenID = 0;
    uint256 public nextPoolID = 0;

    mapping(uint256 => bytes32) poolIDs;
    mapping(uint256 => Position) positions;
    mapping(bytes32 => Pool) pools;


    function mint(address _owner, bytes32 _poolID, uint256 _tickLower, uint256 _tickUpper, uint24 _amount) public {
        _mint(_owner, nextTokenID);
        positions[ nextTokenID ] = new Position(_poolID, _tickLower, _tickUpper, _amount);
        _setTokenURI(nextTokenID, positions[nextTokenID].generateOnchainNFT(nextTokenID, _owner, pools[_poolID]));
        nextTokenID++;
    }

    function nftInfo(uint256 _tokenID) public view returns (address, uint256, uint256, uint24, bytes32) {
        (bytes32 _poolID, uint256 _tickLower, uint256 _tickUpper, uint24 _amount) = positions[ _tokenID ].positionInfo();
        return (ownerOf(_tokenID), _tickLower, _tickUpper, _amount, _poolID);
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

}