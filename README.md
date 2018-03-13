[![Build Status](https://travis-ci.org/alext234/crypto-zombies-l5.svg?branch=refactor-into-library)](https://travis-ci.org/alext234/crypto-zombies-l5)


# CryptoZombies, lesson 5

# Overview

This is from the tutorial at https://share.cryptozombies.io/en/lesson/5/share/AlexT?id=Z2l0aHVifDE2MjQ1MjI=

ERC721 Token has been implemented in this lesson.

In addition, unit tests and testnet-based tests have been added.

This is similar to the original code, except that some part of the code has been refactored into 
a library `UtilLib`. Deploying the original contract `ZombieOwnership` requires 
first deploying the library, linking the library address to the contract and then 
finally deploying the contract itself.

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

A contract has been deployed on the `Rinkeby` testnet at 
https://rinkeby.etherscan.io/address/0xae53417c65f8d05879bc0ad3f52700cbd154411d


Below are the steps used:

## Create wallet on `Rinkeby` network

- Go to https://www.myetherwallet.com/ and follow the steps to generate a wallet 
(make sure to select `Network Rinkeby (infura.io)`).

- Download the wallet key as a keystore file into a directory such as `~/keystore-directory`.

- Have some `ETH` sent to the wallet address through online faucet.

## Deploy with `dapp`

Make a clean build (this is necessary because after a `dapp test` it does replace the library 
placeholders with the address of libraries deployed in the test environment).

```
dapp clean
dapp build
```

Set environment variables to be used by `dapp`:
```
export ETH_KEYSTORE=~/keystore-directory/
export ETH_FROM=<wallet-address>
export ETH_RPC_URL=https://rinkeby.infura.io
export ETH_GAS=4500000
```
Deploy `UtilLib` and take note of its address

```
dapp create UtilLib

+ seth send --create out/UtilLib.bin 'UtilLib()'
Ethereum account passphrase (not echoed): seth-send: Published transaction with 522 bytes of calldata.
seth-send: 0x2588c62c489481c3dd22d309f9a870b0f7efd4bb225bc7a2cf8b7fdc93274fd5
seth-send: Waiting for transaction receipt.....
....
seth-send: Transaction included in block 1924225.
0xf6130d36fe4a2c91fafc8cd0900329b26ddb0c7c

```

Rebuild `ZombieOwnership` and link with `UtilLib` at the deployed address:

```
solc --overwrite --libraries 'src/UtilLib.sol:UtilLib:0xf6130d36fe4a2c91fafc8cd0900329b26ddb0c7c' --bin    src/ZombieOwnership.sol -o out/

```
Deploy the `ZombieOwnership` contract:

```
dapp create ZombieOwnership
```
