# ZKP2P Periphery

**Repository for periphery contracts of the core ZKP2P protocol**

## Usage
1. Install [Foundry](https://book.getfoundry.sh/getting-started/installation)
2. Clone repository
3. Run `forge install` to build dependencies
4. Run `forge test` to run tests

## Deploy
1. `cp .env.default .env`
2. For `DEPLOY_IDENTIFIER`, options are `localhardhat`, `goerli_staging`, `base_staging`, `base_production`
1. `source .env`
2. For local deploy, start your local chain and run `forge script script/ProofOfUpiNFTV1Script.s.sol:ProofOfUpiNFTV1Script --fork-url http://localhost:8545 --broadcast`
3. For Goerli Staging `forge script script/ProofOfVenmoNFTV2.s.sol:ProofOfVenmoNFTV2Script --rpc-url $GOERLI_RPC_URL --broadcast --verify -vvvv`
4. For Base Mainnet `forge script script/ProofOfVenmoNFTV2.s.sol:ProofOfVenmoNFTV2Script --rpc-url $GOERLI_RPC_URL --broadcast --etherscan-api-key $BASESCAN_API_KEY --verify -vvvv`

## Contracts

### NFTDescriptor
External library that generates image SVG and other metadata for zkNFTs. Forked and modified from Uniswap V3's [NFTDescriptor](https://github.com/Uniswap/v3-periphery/blob/main/contracts/libraries/NFTDescriptor.sol).

### NFTSVG
External library that generates image SVGs for zkNFTs. Forked and modified from Uniswap V3's [NFTSVG](https://github.com/Uniswap/v3-periphery/blob/main/contracts/libraries/NFTSVG.sol).

### ProofOfVenmoNFT
A zkNFT soulbound token that proves you are a Venmo user in ZKP2P. Can only be minted once for each registered Ethereum address.

### ProofOfUPINFT
A zkNFT soulbound token that proves you are an UPI user in ZKP2P. Can only be minted once for each registered Ethereum address.
