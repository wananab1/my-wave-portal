// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
	uint256 totalWaves;

	event NewWave(address indexed from, uint256 timestamp, string message);

	struct Wave {
		address waver;     // waveを送ったユーザーのアドレス
		string message;    // ユーザーの送ったメッセージ
		uint256 timestamp; // タイムスタンプ
	}

	// 送られてきた全てのwaveを保存する配列
	Wave[] waves;

	constructor() {
		console.log("I AM SMART CONTRACT. POG.");
	}

	function wave(string memory _message) public {
		totalWaves += 1;
		console.log("%s waved w/ message %s", msg.sender, _message);

		// Waveを配列に保存
		waves.push(Wave(msg.sender, _message, block.timestamp));

		// eventを発行
		emit NewWave(msg.sender, block.timestamp, _message);
	}

	// website用にWaveの配列を全て返す
	function getAllWaves() public view returns(Wave[] memory) {
		return waves;
	}

	function getTotalWaves() public view returns (uint256) {
		console.log("We have %d total waves!", totalWaves);
		return totalWaves;
	}
}
