# ZKP2P Periphery

**Repository for periphery contracts of the core ZKP2P protocol**

## Usage
1. Install [Foundry](https://book.getfoundry.sh/getting-started/installation)
2. Clone repository
3. Run `forge install` to build dependencies
4. Run `forge test` to run tests

## Deploy
Run `forge script script/ProofOfP2PNFTV1.s.sol:ProofOfP2PNFTV1Script --fork-url http://localhost:8545 --broadcast`

## Contracts

### NFTDescriptor
External library that generates image SVG and other metadata for zkNFTs. Forked and modified from Uniswap V3's [NFTDescriptor](https://github.com/Uniswap/v3-periphery/blob/main/contracts/libraries/NFTDescriptor.sol).

### NFTSVG
External library that generates image SVGs for zkNFTs. Forked and modified from Uniswap V3's [NFTSVG](https://github.com/Uniswap/v3-periphery/blob/main/contracts/libraries/NFTSVG.sol).

### ProofOfP2PNFT
A zkNFT soulbound token that proves you are a Venmo user in ZKP2P. Can only be minted once for each registered Ethereum address.
