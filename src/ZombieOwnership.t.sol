pragma solidity ^0.4.19;

import "ds-test/test.sol";
import "./ZombieOwnership.sol";

contract ZombieOwner {
	ZombieOwnership zombieOwnership;
	function ZombieOwner(ZombieOwnership _zombieOwnership) public {
		zombieOwnership = _zombieOwnership;
	}
	
	function createRandomZombie(string _name) public {
		zombieOwnership.createRandomZombie(_name);
	}
	
	function transfer(address _to, uint256 _tokenId) public {
		zombieOwnership.transfer(_to, _tokenId);
	}
	
	function approve(address _to, uint256 _tokenId) public {
		zombieOwnership.approve(_to, _tokenId);
	}

	function takeOwnership(uint256 _tokenId) public {
		zombieOwnership.takeOwnership(_tokenId);
	}

}

contract ZombieOwnershipTest is DSTest {
	
	ZombieOwnership zombieOwnership;
	
	ZombieOwner owner1;
	ZombieOwner owner2;
	
	function setUp() public {
		zombieOwnership = new ZombieOwnership();
		owner1 = new ZombieOwner(zombieOwnership);
		owner2 = new ZombieOwner(zombieOwnership);
	}
	
	
	// below mainly are the tests for the ERC721 interface
	function test_balanceOf() public {
		owner1.createRandomZombie("0");
		assert(zombieOwnership.balanceOf(owner1) == 1);
		// TODO: should feedAndMultiply and then verifiy of the balance increases
	}
	
	function test_ownerOf() public {
		owner1.createRandomZombie("0");
		owner2.createRandomZombie("1");
		
		assert(zombieOwnership.ownerOf(0) == address(owner1));
		assert(zombieOwnership.ownerOf(1) == address(owner2));
	
	}
	
	function test_transfer() public {
		owner1.createRandomZombie("0");
		owner2.createRandomZombie("1");
		owner1.transfer(owner2, 0);
		assert(zombieOwnership.balanceOf(owner1) == 0);
		assert(zombieOwnership.balanceOf(owner2) == 2);
		assert(zombieOwnership.ownerOf(0) == address(owner2));
		assert(zombieOwnership.ownerOf(1) == address(owner2));
	}
	
	function test_approveAndTakeOwnership() public {
		owner1.createRandomZombie("0");
		owner1.approve(owner2, 0);
		assert(zombieOwnership.balanceOf(owner1) == 1);
		assert(zombieOwnership.ownerOf(0) == address(owner1));
		
		owner2.takeOwnership(0);
		assert(zombieOwnership.balanceOf(owner1) == 0);
		assert(zombieOwnership.balanceOf(owner2) == 1);
		assert(zombieOwnership.ownerOf(0) == address(owner2));
	}
	
	function testFail_approveAndWrongUserTakeOwnership() public {
		owner1.createRandomZombie("0");
		owner1.approve(owner2, 0);
		ZombieOwner owner3 = new ZombieOwner(zombieOwnership);
		
		owner3.takeOwnership(0);// not allowed; should throw
	}
}