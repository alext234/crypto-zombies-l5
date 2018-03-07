[![Build Status](https://travis-ci.org/alext234/crypto-zombies-l5.svg?branch=master)](https://travis-ci.org/alext234/crypto-zombies-l5)

# CryptoZombies, lesson 5

# Overview

This is from the tutorial at https://share.cryptozombies.io/en/lesson/5/share/AlexT?id=Z2l0aHVifDE2MjQ1MjI=

ERC721 Token has been implemented in this lesson.

In addition, unit tests and testnet-based tests have been added.

# Build 

To build and test, `dapp` is required, similar to this repository https://github.com/alext234/dapp-tutorial.

- Install `dapp.tools`:

```
curl https://nixos.org/nix/install > nix-install.sh
nix-env -iA dapphub.master.{dapp,seth,hevm,solc}

```
- Build

```
make all
```

# Tests

## Unit test

```
make test
```


## Testnet tests


On another terminal launch testnet with 2 accounts

```
dapp testnet --accounts=2
```

Now run the test script

```
./testnet_script.sh
```

# Deploy

A contract has been deployed on the `Kovan` testnet at 
https://kovan.etherscan.io/address/0xc4e157d452fbaa20767cfd051099a4ccb7a9a911

Below are the steps used:

## Create wallet on `Kovan` network

- Go to https://www.myetherwallet.com/ and follow the steps to generate a wallet 
(make sure to select `Network Kovan (infura.io)`).

- Download the wallet key as a keystore file into a directory such as `~/keystore-directory`.

- Have some `Kovan ETH` sent to the wallet address (one way is to request 
  through https://gitter.im/kovan-testnet/faucet). This is used to pay for the transaction
  cost.

## Deploy with `dapp`

Set environment variables to be used by `dapp`:
```
export ETH_KEYSTORE=~/keystore-directory/
export ETH_FROM=<wallet-address>
export ETH_RPC_URL=https://kovan.infura.io
export ETH_GAS=4500000
```

Run `dapp deploy` command

```
dapp create ZombieOwnership

+ seth send --create out/ZombieOwnership.bin 'ZombieOwnership()'
Ethereum account passphrase (not echoed): seth-send: Published transaction with 8692 bytes of calldata.
seth-send: 0x56f0eeed31b83cb65db19b8e88d11ba53f2ff1349b22cfc6072be783224a7f7c
seth-send: Waiting for transaction receipt.....
seth-send: Transaction included in block 6172760.
0xc4e157d452fbaa20767cfd051099a4ccb7a9a911
```

The deployed contract can be viewed on etherscan at https://kovan.etherscan.io/address/<contract-address>

## Have the source code verified

Etherscan does not allow uploading multiple source files. Therefore the first 
step is to have a *flattened* version of the contract, which means the contract 
itself and all dependencies in one single file.

- `solidity_flattener` can be used to flatten the contract

Python3 is required.
```
(activate python3 virtualenv)
pip install solidity_flattener
solidity_flattener  src/ZombieOwnership.sol --output flattened.sol
```

- Upload the file `flattened.sol` to etherscan.io and it should be verified successfully.


## Interact with the deployed contract

Following are some examples of interaction with the contract
`0xc4e157d452fbaa20767cfd051099a4ccb7a9a911` deployed on Kovan testnet.


### With `seth`

Having 2 accounts will be helpful
try out the transfer of zombies based on the ERC721 interface.

Some environment variables have to be set:

```
export SETH_CHAIN=kovan
export ETH_GAS=450000
export ETH_KEYSTORE=~/keystore-directory/

export CONTRACT=0xc4e157D452FBaA20767cFD051099a4ccb7a9A911

```

Use `seth` from account1 to create a zombie:
```
export ETH_FROM=<account1-address>
seth send $CONTRACT 'createRandomZombie(string)' 'a1'
```

Use `seth` from account2 to create a zombie:
```
export ETH_FROM=<account2-address>
seth send $CONTRACT 'createRandomZombie(string)' 'a2'
```

Verify the owners of the 2 zombies:
```
seth call $CONTRACT 'ownerOf(uint256)' 0
seth call $CONTRACT 'ownerOf(uint256)' 1
```
From account2, call `approve()` to transfer the ownership of its zombie to account1:

```
export ETH_FROM=<account2-address>
seth send $CONTRACT 'approve(address,uint256)' <account1-address> 1
```

From account1, call `takeOwnership()` of the zombie:
```
export ETH_FROM=<account1-address>
seth send $CONTRACT 'takeOwnership(uint256)'  1
```

Verify the number of zombies each account now has:
```
seth call $CONTRACT 'balanceOf(address)' <account1-address>
seth call $CONTRACT 'balanceOf(address)' <account2-address>
```

### Read-only on etherscan

All contract reads can be done interactively on the browser via etherscan site:
https://kovan.etherscan.io/address/0xc4e157d452fbaa20767cfd051099a4ccb7a9a911#readContract
