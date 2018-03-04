#!/usr/bin/env bash

# this script tests the interactions with the contract through a testnet

# echo on (print out each command as it is executed)
set -x 

ETH_FROM=$(seth rpc eth_accounts|sed 1p -n)

ACCOUNT1=$(seth rpc eth_accounts|sed 1p -n)
ACCOUNT2=$(seth rpc eth_accounts|sed 2p -n)
export ETH_RPC_PORT=8545
export ETH_KEYSTORE=~/.dapp/testnet/8545/keystore
export ETH_GAS=3500000

echo "" > empty-password.txt
zombieHelper=$(dapp create  ZombieHelper  -S empty-password.txt)

txhash=$(seth --async --from $ACCOUNT1 --password empty-password.txt send $zombieHelper 'createRandomZombie(string)' 'a1')
txstatus=$(seth receipt $txhash status)
if [ "$txstatus" -ne "1" ]
then
	exit 1
fi

# create another zombie from the same user; this should fail
txhash=$(seth  --async  --from $ACCOUNT1 --password empty-password.txt send $zombieHelper 'createRandomZombie(string)' 'a2')
txstatus=$(seth receipt $txhash status)
if [ "$txstatus" -ne "0" ]
then
	exit 1
fi


seth --from $ACCOUNT2 --password empty-password.txt send $zombieHelper 'createRandomZombie(string)' 'b1'  

seth call $zombieHelper 'getZombiesByOwner(address)(uint[])' $ACCOUNT1
seth call $zombieHelper 'getZombiesByOwner(address)(uint[])' $ACCOUNT2

zombiesArray1=`seth call $zombieHelper 'getZombiesByOwner(address)(uint[])' $ACCOUNT1`
#get the number of items in zombiesArray1
numZombiesAccount1=`echo $zombiesArray1 | tr -d '[]' | tr ',' '\n' | wc -l`

if [ "$numZombiesAccount1" -ne "1" ]
then
	exit 1
fi

export zombiesArray2=`seth call $zombieHelper 'getZombiesByOwner(address)(uint[])' $ACCOUNT2`
export numZombiesAccount2=`echo $zombiesArray2 | tr -d '[]' | tr ',' '\n' | wc -l`

if [ "$numZombiesAccount2" -ne "1" ]
then
	exit 1
fi
