// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "base64-sol/base64.sol";
import "./Position.sol";
import "./Pool.sol";
import "./OnchainNFT.sol";

contract PositionNFT is ERC721URIStorage, OnchainNFT {
    constructor () ERC721("PositionNFT", "PNFT") {}

    uint256 public nextTokenID = 0;
    uint256 public nextPoolID = 0;

    mapping(uint256 => bytes32) poolIDs;
    mapping(uint256 => Position) positions;
    mapping(bytes32 => Pool) pools;


    function mint(address _owner, bytes32 _poolID, uint256 _tickLower, uint256 _tickUpper, uint24 _amount) public {
        _mint(_owner, nextTokenID);
        positions[ nextTokenID ] = new Position(_poolID, _tickLower, _tickUpper, _amount);
        _setTokenURI(nextTokenID, generateOnchainNFT(nextTokenID));
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

    function burn(uint256 _tokenID) public {
        _burn(_tokenID);
    }

    function generateOnchainNFT(uint256 _tokenID) internal view returns (string memory) {
        (address owner, uint256 _tickLower, uint256 _tickUpper, uint24 _amount, bytes32 _poolID) = nftInfo(_tokenID);
        (string memory token0, string memory token1, uint24 fee) = poolInfo(_poolID);
        string memory svg = drawSVG(Strings.toHexString(owner), token0, token1, Strings.toString(fee), Strings.toString(_tickLower), Strings.toString(_tickUpper), Strings.toString(_amount), _poolID);
        string memory svgBase64Encoded = string(abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(bytes(
                string(abi.encodePacked(svg))
            ))
        ));

        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(
                bytes(abi.encodePacked(
                    '{"name":', string(abi.encodePacked(token0, '/', token1, ' - ', Strings.toString(fee), ' ppm')),
                    ',"image":', string(abi.encodePacked('"', svgBase64Encoded, '"')),
                    ',"description":', string(abi.encodePacked('Position NFT #', Strings.toString(_tokenID))),
                    '}'
                ))
            )
        ));
    }
}