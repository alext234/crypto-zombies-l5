[![Build Status](https://travis-ci.org/alext234/crypto-zombies-l5.svg?branch=master)](https://travis-ci.org/alext234/crypto-zombies-l5)

# CryptoZombies, lesson 5

# Overview

This is from the tutorial at  TBD
 

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


### Testnet tests


On another terminal launch testnet with 2 accounts

```
dapp testnet --accounts=2
```

Now run the test script

```
./testnet_script.sh
```

