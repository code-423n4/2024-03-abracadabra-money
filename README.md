# Abracadabra MIMSwap On Blast
This repo is a curated version of our main repository `https://github.com/Abracadabra-money/abracadabra-money-contracts` so that it contains the minimal codebase required for this product.

## Prerequisites
- Node ideally v20 but earlier version should work as well.
- Yarn
- Linux / MacOS / WSL 2
- Blast archive RPC (ankr, quicknode for example)
- Arbitrum archive RPC url to run the `LockingMultiRewards` tests
- Ethereum archive RPC url to run the `MagicLpAggregator` tests
- Set the required rpc urls `BLAST_RPC_URL`, `MAINNET_RPC_URL` and `ARBITRUM_RPC_URL` in `.env.defaults` or ideally a `.env` file.

## Install
- yarn

## Tests
- yarn test -vv

## Scripts
We are using foundry scripts for any live deployments and the same ones are used when fork testing.

## Blast
Mocks are used for Blast precompiles as it doesn't seems to be supported natively by Foundry at this time.
They can be found in `utils/mocks/BlastMock.sol`. It's only used when fork testing and deploying.

## Intro
MIMSwap is a fork of dodo v2 but refactored so it's more aligned with our needs. The math formula weren't changed.
- We ported it to Solidity 0.8. You can compare with the original repo here:
https://github.com/DODOEX/contractV2/tree/main/contracts/DODOStablePool

- We are using a Mix of DSP + private pool
- We made our own Factory  / Router periphery
- MagicLpAggregator would be used to price MagicLP collateral for Cauldrons
- Some contracts were wrapped so it's usuable with Blast L2 yield claiming
- BlastOnboarding is currently live and it's a LLE where people deposit MIM/USDB and once ready we would upgrade BlastOnboarding implementation to use BlastOnboardingBoot
- BlastOnboarding source code is a bit different from the live version because we improved how we can claim the yields post-deployment. It was changed in case we want to run another LLE in the futur.
- BlastOnboardingBoot would create a single MagicLP for MIM/USDB
- People will be able to claim their LP and stake it locked or not to get extra Blast point boosting
- People that deposited unlocked into the LLE can withdraw at any time during and after
- Only the one that locked during the LLE can claim a share of the MagicLP and optionaly stake (locked or not).
- MagicLP staking uses LockingMultiRewards
- LockingMultiRewards is a fork of Curve MultiRewards.
- LockingMultiRewards allows to stake, lock or unlocked during 13 weeks. Locks are released by a Gelato task offchain. An epoch is 7 days. Rewards are distributed during the epoch. The rewards claimed during an epoch are only available the other epoch + the rewards from the previous epoch if any.

-----------

## Files in scope
src/blast/BlastDapp.sol
src/blast/BlastBox.sol
src/blast/BlastGovernor.sol
src/blast/BlastMagicLP.sol
src/blast/BlastOnboarding.sol
src/blast/BlastOnboardingBoot.sol
src/blast/BlastTokenRegistry.sol
src/blast/BlastWrappers.sol
src/blast/libraries/BlastPoints.sol
src/blast/libraries/BlastYields.sol
src/mimswap/MagicLP.sol
src/mimswap/auxiliary/FeeRateModel.sol
src/mimswap/auxiliary/FeeRateModelImpl.sol
src/mimswap/libraries/DecimalMath.sol
src/mimswap/libraries/Math.sol
src/mimswap/libraries/PMMPricing.sol
src/mimswap/periphery/Factory.sol
src/mimswap/periphery/Router.sol
src/oracles/aggregators/MagicLpAggregator.sol
src/staking/LockingMultiRewards.sol

Around 1965 LOC

## Scoping Details 

- If you have a public code repo, please share it here: https://github.com/Abracadabra-money/abracadabra-money-contracts 
- How many contracts are in scope?: 22
- Total SLoC for these contracts?: 1965
- How many external imports are there?: 21 
- How many separate interfaces and struct definitions are there for the contracts within scope?: 2 structs
- Does most of your code generally use composition or inheritance?: Inheritance   
- How many external calls?: 10
- What is the overall line coverage percentage provided by your tests?: 60
- Is this an upgrade of an existing system?: True - MIMSwap + MagicLP oracle to be use for Cauldrons. Blast Versions of the MIMSwap/DegenBox/CauldronV4 contracts to allow yields (mostly inherited except BlastMagicLP), MultiReward with Locking, BlastOnboarding (an LLE to bootstrap liquidity for MIMSwap launch) and an Upgrade implementation for the BlastOnboarding: BlastOnboardingBoot to bootstrap the liquidity and allow users to claim their LP share and stake automatically
- Check all that apply (e.g. timelock, NFT, AMM, ERC20, rollups, etc.): AMM, Uses L2, Multi-Chain, ERC-20 Token 
- Is there a need to understand a separate part of the codebase / get context in order to audit this part of the protocol?: False   
- Please describe required context:
- Does it use an oracle?: Chainlink
- Describe any novel or unique curve logic or mathematical models your code uses: MIMSwap is a fork of dodo v2 
- Is this either a fork of or an alternate implementation of another project?: True 
- Does it use a side-chain?:
