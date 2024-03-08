# Abracadabra Mimswap audit details
- Total Prize Pool: $63,000 in USDC
  - HM awards: $49,875 in USDC
  - QA awards: $1,312.50 in USDC 
  - Gas awards: $1,312.50 in USDC
  - Judge awards: $6,000 in USDC
  - Lookout awards: $4000 in USDC
  - Scout awards: $500 in USDC
 
- Join [C4 Discord](https://discord.gg/code4rena) to register
- Submit findings [using the C4 form](https://code4rena.com/contests/2024-03-abracadabra-mimswap/submit)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts March 7, 2024, 20:00 UTC
- Ends March 12, 2024, 20:00 UTC

## Automated Findings / Publicly Known Issues

The 4naly3er report can be found [here](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/4naly3er-report.md).


_Note for C4 wardens: Anything included in this `Automated Findings / Publicly Known Issues` section is considered a publicly known issue and is ineligible for awards._

# Abracadabra MIMSwap On Blast
This repo is a curated version of our main repository `https://github.com/Abracadabra-money/abracadabra-money-contracts` so it contains the minimal codebase required for this product.

# Overview

MIMSwap is a fork of Dodo V2 but refactored, so it's more aligned with our needs. The math formula wasn't changed.

- We ported it to Solidity 0.8. You can compare it with the original repo here:
https://github.com/DODOEX/contractV2/tree/main/contracts/DODOStablePool

- We are using a Mix of DSP + private pool
- We made our own Factory  / Router periphery
- MagicLpAggregator would be used to price MagicLP collateral for Cauldrons. Something to note is that the MagicLP Oracle is only meant for closed-together price pool. It's just that the oracle is not meant to be used for any kind of MagicLP, just for closely priced tokens like MIM/USDB.
- Some contracts were wrapped so it's usable with Blast L2 yield claiming
- BlastOnboarding is currently live and it's an LLE where people deposit MIM/USDB once ready we would upgrade the BlastOnboarding implementation to use BlastOnboardingBoot
- BlastOnboarding source code is a bit different from the live version because we improved how we can claim the yields post-deployment. It was changed in case we want to run another LLE in the future.
- BlastOnboardingBoot would create a single MagicLP for MIM/USDB
- People will be able to claim their LP and stake it locked or not to get extra Blast point boosting
- People who deposited unlocked into the LLE can withdraw at any time during and after
- Only the one that locked during the LLE can claim a share of the MagicLP and optionally stake (locked or not).
- MagicLP staking uses LockingMultiRewards
- LockingMultiRewards is a fork of Curve MultiRewards.
- LockingMultiRewards allows you to stake, lock, or unlock for 13 weeks. Locks are released by a Gelato task offchain. An epoch is 7 days. Rewards are distributed during the epoch. The rewards claimed during an epoch are only available in the other epoch + the rewards from the previous epoch if any.


## Links

- **Previous audits:** [Here](https://github.com/Abracadabra-money/abracadabra-money-contracts/blob/main/audits/2024-02-06_Abracadabra_LockingMultiRewards.pdf) 
- **Documentation:** [Here](https://docs.abracadabra.money/learn/)
- MIMSwap V2 is based on [DODO V2](https://docs.dodoex.io/en/home/what-is-dodo)
- DODO PMM Algorithm [Whitepaper](https://www.securities.io/wp-content/uploads/2022/05/DODO.pdf)

  Note From Abracadabra Money: _It's the same algo for V2 but in V2 the Oracle is replaced with an I constant._
- **Website:** [Here](https://abracadabra.money/)
- **Twitter:** [Here](https://twitter.com/MIM_Spell)
- **Discord:** [Here](https://discord.com/invite/mim)


# Scope

| Contract| SLOC| 
| :------- | -------: |
|[src/blast/BlastDapp.sol](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastDapp.sol) |   7   |
|[src/blast/BlastBox.sol](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastBox.sol) |    65  |
|[src/blast/BlastGovernor.sol](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastGovernor.sol) |   35   |
|[src/blast/BlastMagicLP.sol](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastMagicLP.sol) |  76    |
|[src/blast/BlastOnboarding.sol](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboarding.sol) |    168 |
|[src/blast/BlastOnboardingBoot.sol](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol) |   109   |
|[src/blast/BlastTokenRegistry.sol](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastTokenRegistry.sol) |   15   |
|[src/blast/BlastWrappers.sol](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastWrappers.sol) |   57   |
|[src/blast/libraries/BlastPoints.sol](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/libraries/BlastPoints.sol) |   9   |
|[src/blast/libraries/BlastYields.sol](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/libraries/BlastYields.sol) |    51  |
|[src/mimswap/MagicLP.sol](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol) |  444   |
|[src/mimswap/auxiliary/FeeRateModel.sol](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/auxiliary/FeeRateModel.sol) |  33    |
|[src/mimswap/auxiliary/FeeRateModelImpl.sol](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/auxiliary/FeeRateModelImpl.sol) |    9  |
|[src/mimswap/libraries/DecimalMath.sol](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/DecimalMath.sol) |   39   |
|[src/mimswap/libraries/Math.sol](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/Math.sol) |   105   |
|[src/mimswap/libraries/PMMPricing.sol](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/PMMPricing.sol) |  110    |
|[src/mimswap/periphery/Factory.sol](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Factory.sol) |  99    |
|[src/mimswap/periphery/Router.sol](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Router.sol) |   369   |
|[src/oracles/aggregators/MagicLpAggregator.sol](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/oracles/aggregators/MagicLpAggregator.sol) |   38   |
|[src/staking/LockingMultiRewards.sol](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/staking/LockingMultiRewards.sol)    |  422    |

## Out of scope

* The items acknowledged in the [previous audit](https://github.com/Abracadabra-money/abracadabra-money-contracts/blob/main/audits/2024-02-06_Abracadabra_LockingMultiRewards.pdf) are Out Of Scope.

* `BlastOnboarding` Contract Known issues (acknowledged):
The BlastOnboarding contract is a proxy, but it has several declared storage variables and functions. As a result, the contract is prone to storage and function selector collision.

* `BlastBox` Contract Known issues (acknowledged):
If the owner does not want to enable native yield for a token with the function `setTokenEnabled`, that token will have the default mode which is AUTOMATIC for WETH and USDB. When a token is in AUTOMATIC mode, the balance of the token in the contract increases as yield is gained. However, the DegenBox contract is unable to support rebasing tokens.

* Any reports submitted outside of the scoped contracts are Out Of Scope.


## Scoping Details 

```
- If you have a public code repo, please share it here: https://github.com/Abracadabra-money/abracadabra-money-contracts 
- How many contracts are in scope?: 22
- Total SLoC for these contracts?: 1965
- How many external imports are there?: 21 
- How many separate interfaces and struct definitions are there for the contracts within scope?: 2 structs
- Does most of your code generally use composition or inheritance?: Inheritance   
- How many external calls?: 10
- What is the overall line coverage percentage provided by your tests?: 60
- Is this an upgrade of an existing system?: True - MIMSwap + MagicLP oracle to be used for Cauldrons. Blast Versions of the MIMSwap/DegenBox/CauldronV4 contracts to allow yields (mostly inherited except BlastMagicLP), MultiReward with Locking, BlastOnboarding (an LLE to bootstrap liquidity for MIMSwap launch) and an Upgrade implementation for the BlastOnboarding: BlastOnboardingBoot to bootstrap the liquidity and allow users to claim their LP share and stake automatically
- Check all that apply (e.g. timelock, NFT, AMM, ERC20, rollups, etc.): AMM, Uses L2, Multi-Chain, ERC-20 Token 
- Is there a need to understand a separate part of the codebase / get context to audit this part of the protocol?: False   
- Please describe required context:
- Does it use an oracle?: Chainlink
- Describe any novel or unique curve logic or mathematical models your code uses: MIMSwap is a fork of dodo v2 
- Is this either a fork of or an alternate implementation of another project?: True 
- Does it use a side-chain?:
- Describe any specific areas you would like addressed:
```

## Prerequisites
- Node ideally v20 but earlier version should work as well.
- Yarn
- Linux / MacOS / WSL 2
- Blast archive RPC (Ankr, Quicknode for example)
- Arbitrum archive RPC URL to run the `LockingMultiRewards` tests
- Ethereum archive RPC URL to run the `MagicLpAggregator` tests
- Set the required rpc urls `BLAST_RPC_URL`, `MAINNET_RPC_URL` and `ARBITRUM_RPC_URL` in `.env.defaults` or ideally a `.env` file.

## Install
- yarn

## Tests
- yarn test -vv

## Scripts
We are using foundry scripts for any live deployments and the same ones are used when fork testing.

## Blast
Mocks are used for Blast precompiles as it doesn't seem to be supported natively by Foundry at this time.
They can be found in `utils/mocks/BlastMock.sol`. It's only used when fork testing and deploying.

## Miscellaneous

Employees of Abracadabra Money and employees' family members are ineligible to participate in this audit.
