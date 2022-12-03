// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Strings.sol";
import "base64-sol/base64.sol";

contract OnchainNFT {  
  function toHex(bytes32 data) public pure returns (string memory) {
		return string(abi.encodePacked("0x", toHex16(bytes16(data)), toHex16(bytes16(data << 128))));
	}

	function toHex16(bytes16 data) internal pure returns (bytes32 result) {
		result =
			(bytes32(data) & 0xFFFFFFFFFFFFFFFF000000000000000000000000000000000000000000000000) |
			((bytes32(data) & 0x0000000000000000FFFFFFFFFFFFFFFF00000000000000000000000000000000) >> 64);
		result =
			(result & 0xFFFFFFFF000000000000000000000000FFFFFFFF000000000000000000000000) |
			((result & 0x00000000FFFFFFFF000000000000000000000000FFFFFFFF0000000000000000) >> 32);
		result =
			(result & 0xFFFF000000000000FFFF000000000000FFFF000000000000FFFF000000000000) |
			((result & 0x0000FFFF000000000000FFFF000000000000FFFF000000000000FFFF00000000) >> 16);
		result =
			(result & 0xFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000) |
			((result & 0x00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000) >> 8);
		result =
			((result & 0xF000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F000) >> 4) |
			((result & 0x0F000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F00) >> 8);
		result = bytes32(
			0x3030303030303030303030303030303030303030303030303030303030303030 +
				uint256(result) +
				(((uint256(result) + 0x0606060606060606060606060606060606060606060606060606060606060606) >> 4) &
					0x0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F) *
				7
		);
  }

  function drawSVG(string memory _owner, string memory _token0, string memory _token1, string memory _fee, string memory _tickLower, string memory _tickUpper, string memory _amount, bytes32 _poolID) public pure returns (string memory) {
    string memory svgString = string(abi.encodePacked(
      '<svg viewBox="0 0 300 500" xmlns="http://www.w3.org/2000/svg">',
      '<rect width="300" height="500" rx="40" ry="40" fill="#122347"/>',
      '<text transform="translate(56 470)" fill="#fff" font-family="Roboto" font-size="45"><tspan>', _token0, '/', _token1, '</tspan></text>',
      '<text transform="rotate(90 -1 18)" fill="#fff" font-family="Roboto" font-size="12"><tspan>', toHex(_poolID), '</tspan></text>',
      '<text transform="rotate(-90 345 60)" fill="#fff" font-family="Roboto" font-size="18"><tspan>', _owner, '</tspan></text>',
      '<text transform="translate(50 116)" fill="#fff" font-family="Roboto" font-size="20"><tspan>Min tick</tspan><tspan x="0" y="20">Max tick</tspan><tspan x="0" y="40">Amount</tspan></text>',
      '<text transform="translate(185 116)" fill="#fff" font-family="Roboto" font-size="20"><tspan>', _tickLower, '</tspan><tspan x="0" y="20">', _tickUpper, '</tspan><tspan x="0" y="40">', _amount, ' ETH</tspan></text>',
      '<text transform="translate(50 246)" fill="#fff" font-family="Roboto" font-size="20"><tspan>B. token</tspan><tspan x="0" y="20">Q. token</tspan><tspan x="0" y="40">Fee tier</tspan></text>',
      '<text transform="translate(185 246)" fill="#fff" font-family="Roboto" font-size="20"><tspan>', _token0, '</tspan><tspan x="0" y="20">', _token1, '</tspan><tspan x="0" y="40">', _fee, ' ppm</tspan></text>'
    ));

    return string(abi.encodePacked(
      '<svg id="NFT" width="100%" height="100%" version="1.1" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">',
      svgString,
      "</svg>"
    ));
  }
}