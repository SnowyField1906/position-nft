// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Position.sol";
import "./Pool.sol";

contract PositionNFT is ERC721 {
    constructor() ERC721("PositionNFT", "PNFT") {}

    uint256 public nextTokenId = 0;

    mapping(uint256 => Position) public positions;

    function mint(address _owner, int24 _tickLower, int24 _tickUpper, string memory _token0, string memory _token1, uint24 _fee) public {
        uint256 tokenId = nextTokenId++;
        _mint(_owner, tokenId);
        positions[tokenId] = new Position(_tickLower, _tickUpper, _token0, _token1, _fee);
    }

    function nftInfo(uint256 _tokenId) public view returns (address, int24, int24, string memory, string memory, uint24) {
        Position position = positions[_tokenId];
        (string memory token0, string memory token1, uint24 fee) = position.getPoolInfo();
        (int24 tickLower, int24 tickUpper) = position.positionInfo();
        return (ownerOf(_tokenId), tickLower, tickUpper, token0, token1, fee);
    }
    
    function baseURI() internal pure returns (string memory) {
        return "https://snowyfield1906.github.io/pool/";
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        Position position = positions[_tokenId];
        return string(abi.encodePacked(position.getPoolId(), string(abi.encodePacked(_tokenId))));
    }
}