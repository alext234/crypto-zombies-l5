[![Build Status](https://travis-ci.org/alext234/crypto-zombies-l4.svg?branch=master)](https://travis-ci.org/alext234/crypto-zombies-l4)


# CryptoZombies, lesson 4

# Overview

This is from the tutorial at  https://share.cryptozombies.io/en/lesson/4/share/alext?id=WyJnaXRodWJ8MTYyNDUyMiIsMiwxNF0=
 

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

