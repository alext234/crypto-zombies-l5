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
	
	function _transfer(address _from, address _to, uint256 _tokenId) private {
		ownerZombieCount[_to]++;
		ownerZombieCount[_from]--;
		zombieToOwner[_tokenId]=_to;
		Transfer(_from, _to, _tokenId);
	}

	function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId){
		_transfer(msg.sender, _to, _tokenId);
	}

	function approve(address _to, uint256 _tokenId) public {

	}

	function takeOwnership(uint256 _tokenId) public {

	}


}