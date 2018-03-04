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
	
	function test_balanceOf() public {
		owner1.createRandomZombie("0");
		assert(zombieOwnership.balanceOf(owner1) == 1);
		
		owner2.createRandomZombie("1");
		assert(zombieOwnership.balanceOf(owner2) == 1);
		
		assert(zombieOwnership.ownerOf(0) == address(owner1));
		assert(zombieOwnership.ownerOf(1) == address(owner2));
	}

}