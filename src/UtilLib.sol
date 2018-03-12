pragma solidity ^0.4.18;

library UtilLib {
	uint constant dnaDigits_ = 16;
	uint constant dnaModulus_ = 10 ** dnaDigits_;
 
	function dnaDigits() public pure returns(uint) {
		return dnaDigits_;
	}

	function dnaModulus() public pure returns(uint) {
		return dnaModulus_;
	}

	function generateRandomDna(string _str) public pure returns (uint) {
		uint rand = uint(keccak256(_str));
		return rand % dnaModulus_;
	}

}