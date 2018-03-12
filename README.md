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

A contract has been deployed on the `Rinkeby` testnet at 
https://rinkeby.etherscan.io/address/0x72f01f9fbbafb61f363f57d57653e734cce0878d

Below are the steps used:

## Create wallet on `Rinkeby` network

- Go to https://www.myetherwallet.com/ and follow the steps to generate a wallet 
(make sure to select `Network Rinkeby (infura.io)`).

- Download the wallet key as a keystore file into a directory such as `~/keystore-directory`.

- Have some `ETH` sent to the wallet address through online faucet.

## Deploy with `dapp`


Set environment variables to be used by `dapp`:
```
export ETH_KEYSTORE=~/keystore-directory/
export ETH_FROM=<wallet-address>
export ETH_RPC_URL=https://rinkeby.infura.io
export ETH_GAS=4500000
```

Deploy the `ZombieOwnership` contract:

```
dapp create ZombieOwnership
```
