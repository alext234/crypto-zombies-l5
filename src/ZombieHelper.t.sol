pragma solidity ^0.4.19;

import "ds-test/test.sol";
import "./ZombieHelper.sol";


contract ZombieHelperUser {
	ZombieHelper zombieHelper;

	function ZombieHelperUser(ZombieHelper _helper) public {
		zombieHelper = _helper;
	}
	
	function createRandomZombie(string _name) public {
		zombieHelper.createRandomZombie(_name);
	}
	
	function levelUp(uint _zombieId) external payable {
		zombieHelper.levelUp.value(msg.value)(_zombieId);
	}

}

contract ZombieHelperOwner {
	
	ZombieHelper zombieHelper;
	
	function ZombieHelperOwner() public {
		zombieHelper = new ZombieHelper();
	}
	
	function getZombieHelper() public view returns(ZombieHelper) {
		return zombieHelper;
	}

	// a fallback payable function is needed
	// to receive funds, e.g. used in test_withdraw()
	function () external payable {
	}

	function withdraw() public {
		zombieHelper.withdraw();
	}
	
	function setLevelUpFee(uint _fee) external {
		zombieHelper.setLevelUpFee(_fee);
	}
}


contract ZombieHelperTest is DSTest {
	ZombieHelper zombieHelper;
	ZombieHelperOwner owner;
	 
	function setUp() public {
		owner = new ZombieHelperOwner();
		zombieHelper = owner.getZombieHelper();

	}

	function test_levelUp() public {
		zombieHelper.createRandomZombie("a");
		zombieHelper.levelUp.value(0.001 ether)(0);
	}	
	
	function testFail_levelUpWrongAmount() public {
		zombieHelper.createRandomZombie("a");
		
		// not the correct amount of ether sent 
		// so should throw
		zombieHelper.levelUp.value(0.002 ether)(0);
	}
	
	
	function test_withdraw() public {
		
		// have a different user to use the contracr
		ZombieHelperUser user1 = new ZombieHelperUser(zombieHelper);
		user1.createRandomZombie("a");

		// user then pay some money to up the level
		user1.levelUp.value(0.001 ether)(0);
				
		uint balanceBefore = owner.balance;
		
		// now owner should be able to withdraw the same amount
		owner.withdraw();
		uint balanceAfter = owner.balance;
		uint withdrawnAmount = balanceAfter-balanceBefore;
		assert(withdrawnAmount==0.001 ether);
	}	
	
	function testFail_setLevelUpFeeAndUserPayWrongAmount() public {
		uint levelUpFee = 0.00345 ether;
		zombieHelper.setLevelUpFee(levelUpFee);
		
		// have a different user to use the contracr
		ZombieHelperUser user1 = new ZombieHelperUser(zombieHelper);
		user1.createRandomZombie("a");
		
		// wrong amount, should throw
		user1.levelUp.value(levelUpFee - 0.001 ether)(0);
	}
	
	function test_setLevelUpFeeAndMultipleUsers() public {
	
		// set a different levelUpFee than default
		uint levelUpFee = 0.00345 ether;
		owner.setLevelUpFee(levelUpFee);
		
		// have multiple users the contracr
		ZombieHelperUser user1 = new ZombieHelperUser(zombieHelper);
		user1.createRandomZombie("a");
		ZombieHelperUser user2 = new ZombieHelperUser(zombieHelper);
		user2.createRandomZombie("b");
		
		// users start paying money to up the levels
		user1.levelUp.value(levelUpFee)(0);
		user2.levelUp.value(levelUpFee)(1);
		
		uint balanceBefore = owner.balance;
		
		// now owner should be able to withdraw the same amount
		owner.withdraw();
		uint balanceAfter = owner.balance;
		uint withdrawnAmount = balanceAfter-balanceBefore;
		assert(withdrawnAmount==levelUpFee * 2);	
	}
}