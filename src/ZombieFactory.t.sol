pragma solidity ^0.4.19;

import "ds-test/test.sol";

import "./ZombieFactory.sol";

contract ZombieFactoryUser {
    ZombieFactory factory;
    
    function ZombieFactoryUser(ZombieFactory factory_) public {
        factory = factory_;
    }
    
    function createRandomZombie(string _name) public {
        factory.createRandomZombie(_name);
    }

}

contract ZombieFactoryTest is DSTest {
    ZombieFactory factory;

	ZombieFactoryUser user1;
	ZombieFactoryUser user2;
    function setUp() public {
        factory = new ZombieFactory();
        user1 = new ZombieFactoryUser(factory);
        user2 = new ZombieFactoryUser(factory);
    }

    function test_createRandomZombie() public {
        
        assertEq( factory.getZombiesCount(), 0);
        user1.createRandomZombie("a");        
        assertEq( factory.getZombiesCount(), 1);

        user2.createRandomZombie("b");        
        assertEq( factory.getZombiesCount(), 2);
       
        uint aDna = factory.getDnaByIndex(0);
        uint bDna = factory.getDnaByIndex(1);
        
        // different names should lead to different DNAs
        assert( bDna != aDna );
    }

	function testFail_UserCantCreateMoreThanOne() public {
		user1.createRandomZombie("a");      
        assertEq( factory.getZombiesCount(), 1);

	    user1.createRandomZombie("b"); // this should throw       
	}
}
