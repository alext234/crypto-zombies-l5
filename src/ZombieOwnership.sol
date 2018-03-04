pragma solidity ^0.4.19;

import "./ZombieAttack.sol";
import "./erc721.sol";

contract ZombieOwnership is ZombieBattle, ERC721 {
	
	function balanceOf(address _owner) public view returns (uint256 _balance) {
		return ownerZombieCount[_owner];
	}

	function ownerOf(uint256 _tokenId) public view returns (address _owner) {
		return zombieToOwner[_tokenId];
	}
	
	function transfer(address _to, uint256 _tokenId) public {

	}

	function approve(address _to, uint256 _tokenId) public {

	}

	function takeOwnership(uint256 _tokenId) public {

	}


}