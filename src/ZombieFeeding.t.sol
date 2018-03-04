pragma solidity ^0.4.19;

import "ds-test/test.sol";

import "./ZombieFeeding.sol";


contract ZombieFeedingInherited is ZombieFeeding {
	
	function triggerCooldown(uint _zombieId) public {
		Zombie storage zombie = zombies[_zombieId];
		_triggerCooldown(zombie);
	}
	
	function getReadyTime(uint _zombieId) view public returns(uint32) {
		Zombie storage zombie = zombies[_zombieId];
		return zombie.readyTime;
	}
}

contract ZombieFeedingTest is DSTest {
	ZombieFeedingInherited  zombieFeeding;
    
	function setUp() public {
		zombieFeeding = new ZombieFeedingInherited();
	}
    
	function test_feedAndMultiply() public {

		zombieFeeding.createRandomZombie("a");
		
		zombieFeeding.feedAndMultiply(0, 1, "kitty");
		uint dna1 = zombieFeeding.getDnaByIndex(1);
		assertEq(dna1 % 100, 99);
		
		zombieFeeding.feedAndMultiply(0, 1, "nonKitty");        
	}
	
	function test_triggerCooldown() public {
		zombieFeeding.createRandomZombie("a");
		uint32 expectedReadyTimeAfter = uint32(now + 1 days);
		zombieFeeding.triggerCooldown(0);
		uint32 readyTimeAfter = zombieFeeding.getReadyTime(0);
 
		assert(readyTimeAfter == expectedReadyTimeAfter );
	}
}
