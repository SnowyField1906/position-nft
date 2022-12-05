// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/Strings.sol";
import "base64-sol/base64.sol";

contract Position {
    bytes32 poolID;
    uint256 tickLower;
    uint256 tickUpper;
    uint24 amount;

    constructor(
        bytes32 _poolID,
        uint256 _tickLower,
        uint256 _tickUpper,
        uint24 _amount
    ) {
        poolID = _poolID;
        tickLower = _tickLower;
        tickUpper = _tickUpper;
        amount = _amount;
    }

    function positionInfo() public view returns (bytes32, uint256, uint256, uint24) {
        return (poolID, tickLower, tickUpper, amount);
    }

    function generateOnchainNFT(uint256 tokenID, address _owner, string memory token0, string memory token1, uint24 fee) public view returns (string memory) {
        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(
                bytes(abi.encodePacked(
                    '{"name":"', token0, '/', token1, ' - ', Strings.toString(fee), ' ppm",',
                    '"image_data":"', drawSVG(Strings.toHexString(_owner), token0, token1, Strings.toString(fee)), '",',
                    '"description":"Position NFT #', Strings.toString(tokenID), '"}'
                ))
            )
        ));
    }
    
    function toHex(bytes32 data) internal pure returns (string memory) {
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

  function drawSVG(string memory _owner, string memory _token0, string memory _token1, string memory _fee) internal view returns (string memory) {
    return string(abi.encodePacked(
      "<svg viewBox='0 0 300 500' xmlns='http://www.w3.org/2000/svg'>",
      "<rect width='300' height='500' rx='40' ry='40' fill='#122347'/>",
      "<text transform='translate(40 470)' fill='#fff' font-family='Roboto' font-size='45'><tspan>", _token0, "/", _token1, "</tspan></text>",
      "<text transform='rotate(90 -1 18)' fill='#fff' font-family='Roboto' font-size='12'><tspan>", toHex(poolID), "</tspan></text>",
      "<text transform='rotate(-90 381 100)' fill='#fff' font-family='Roboto' font-size='23.5'><tspan>", _owner, "</tspan></text>",
      "<text transform='translate(60 116)' fill='#fff' font-family='Roboto' font-size='20'><tspan>Min tick</tspan><tspan x='0' y='20'>Max tick</tspan><tspan x='0' y='40'>Amount</tspan></text>",
      "<text transform='translate(170 116)' fill='#fff' font-family='Roboto' font-size='20'><tspan>", Strings.toString(tickLower), "</tspan><tspan x='0' y='20'>", Strings.toString(tickUpper), "</tspan><tspan x='0' y='40'>", Strings.toString(amount), " ", _token0, "</tspan></text>",
      "<text transform='translate(60 246)' fill='#fff' font-family='Roboto' font-size='20'><tspan>B. token</tspan><tspan x='0' y='20'>Q. token</tspan><tspan x='0' y='40'>Fee tier</tspan></text>",
      "<text transform='translate(170 246)' fill='#fff' font-family='Roboto' font-size='20'><tspan>", _token0, "</tspan><tspan x='0' y='20'>", _token1, "</tspan><tspan x='0' y='40'>", _fee, " ppm</tspan></text></svg>"
    ));
  }
}