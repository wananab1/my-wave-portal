// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
	uint256 totalWaves;

	// 乱数生成
	uint256 private seed;

	event NewWave(address indexed from, uint256 timestamp, string message);

	struct Wave {
		address waver;     // waveを送ったユーザーのアドレス
		string message;    // ユーザーの送ったメッセージ
		uint256 timestamp; // タイムスタンプ
	}

	// 送られてきた全てのwaveを保存する配列
	Wave[] waves;

	// アドレスと最後にwaveを送った時間をマッピング
	mapping(address => uint256) public lastWavedAt;

	constructor() payable {
		console.log("I AM SMART CONTRACT. POG.");
		// seedの初期化
		seed = (block.timestamp + block.difficulty) % 100;
	}

	function wave(string memory _message) public {
		// 最後のwaveから15分以上経過しているか
		require(
			lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
			"Wait 15m"
		);
		lastWavedAt[msg.sender] = block.timestamp;

		totalWaves += 1;
		console.log("%s has waved!", msg.sender);

		waves.push(Wave(msg.sender, _message, block.timestamp));

		// 次のユーザーのための乱数生成
		seed = (block.timestamp + block.difficulty) % 100;
		console.log("Random # generated: %d", seed);

		if(seed <= 50) {
			console.log("%s won!", msg.sender);

			uint256 prizeAmount = 0.0001 ether;
			require(
				prizeAmount <= address(this).balance,
				"Trying to withdraw more money than the contract has."
			);
			(bool success, ) = (msg.sender).call{value: prizeAmount}("");
			require(success, "Failed to withdraw money from contract.");
		}

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
