// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./Position.sol";

contract PositionNFT is ERC721URIStorage {
    constructor() ERC721("PositionNFT", "PNFT") {}

    uint256 public nextTokenId = 0;

    mapping(uint256 => Position) public positions;

    function mint(address _pool, address _owner, int24 _tickLower, int24 _tickUpper, uint24 _fee) public returns (uint256) {
        uint256 tokenId = nextTokenId;
        nextTokenId = nextTokenId + 1;
        _safeMint(_owner, tokenId);
        positions[tokenId] = new Position(_pool, _owner, _tickLower, _tickUpper, _fee);
        return tokenId;
    }

    function positionInfo(uint256 tokenId) public view returns (address, address, int24, int24, uint24) {
        return positions[tokenId].info();
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://snowyfield1906.github.io/PositionNFT/detail/";
    }

    function tokenURI(uint256 tokenId) public pure override returns (string memory) {
        return string(abi.encodePacked(_baseURI(), tokenId));
    }

}