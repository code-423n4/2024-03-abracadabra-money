# Report


## Gas Optimizations


| |Issue|Instances|
|-|:-|:-:|
| [GAS-1](#GAS-1) | `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings) | 19 |
| [GAS-2](#GAS-2) | Using bools for storage incurs overhead | 7 |
| [GAS-3](#GAS-3) | Cache array length outside of loop | 7 |
| [GAS-4](#GAS-4) | For Operations that will not overflow, you could use unchecked | 215 |
| [GAS-5](#GAS-5) | Avoid contract existence checks by using low level calls | 25 |
| [GAS-6](#GAS-6) | Functions guaranteed to revert when called by normal users can be marked `payable` | 51 |
| [GAS-7](#GAS-7) | `++i` costs less gas compared to `i++` or `i += 1` (same for `--i` vs `i--` or `i -= 1`) | 1 |
| [GAS-8](#GAS-8) | Using `private` rather than `public` for constants, saves gas | 8 |
| [GAS-9](#GAS-9) | Use shift right/left instead of division/multiplication if possible | 7 |
| [GAS-10](#GAS-10) | Increments/decrements can be unchecked in for-loops | 1 |
| [GAS-11](#GAS-11) | Use != 0 instead of > 0 for unsigned integer comparison | 32 |
| [GAS-12](#GAS-12) | WETH address definition can be use directly | 1 |
### <a name="GAS-1"></a>[GAS-1] `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings)
This saves **16 gas per instance.**

*Instances (19)*:
```solidity
File: src/blast/BlastOnboarding.sol

105:             totals[token].locked += amount;

106:             balances[msg.sender][token].locked += amount;

108:             totals[token].unlocked += amount;

109:             balances[msg.sender][token].unlocked += amount;

112:         totals[token].total += amount;

118:         balances[msg.sender][token].total += amount;

125:         balances[msg.sender][token].locked += amount;

127:         totals[token].locked += amount;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboarding.sol)

```solidity
File: src/mimswap/MagicLP.sol

553:                 _BASE_PRICE_CUMULATIVE_LAST_ += getMidPrice() * timeElapsed;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/staking/LockingMultiRewards.sol

380:             amount += _remainingRewardTime * reward.rewardRate;

441:             unlockedSupply += amount;

444:             bal.unlocked += amount;

465:         stakingTokenBalance += amount;

472:             _balances[account].unlocked += amount;

473:             unlockedSupply += amount;

485:         bal.locked += amount;

486:         lockedSupply += amount;

510:             _userLocks[user][_lastLockIndex].amount += amount;

642:                     item.amount += rewardAmount;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/staking/LockingMultiRewards.sol)

### <a name="GAS-2"></a>[GAS-2] Using bools for storage incurs overhead
Use uint256(1) and uint256(2) for true/false to avoid a Gwarmaccess (100 gas), and to avoid Gsset (20000 gas) when changing from ‘false’ to ‘true’, after having been ‘true’ in the past. See [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/58f635312aa21f947cae5f8578638a85aa2519f5/contracts/security/ReentrancyGuard.sol#L23-L27).

*Instances (7)*:
```solidity
File: src/blast/BlastBox.sol

21:     mapping(address => bool) public enabledTokens;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastBox.sol)

```solidity
File: src/blast/BlastMagicLP.sol

21:     mapping(address => bool) public operators;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastMagicLP.sol)

```solidity
File: src/blast/BlastOnboarding.sol

36:     mapping(address token => bool) public supportedTokens;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboarding.sol)

```solidity
File: src/blast/BlastOnboardingBoot.sol

28:     bool public ready;

30:     mapping(address user => bool claimed) public claimed;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol)

```solidity
File: src/blast/BlastTokenRegistry.sol

10:     mapping(address => bool) public nativeYieldTokens;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastTokenRegistry.sol)

```solidity
File: src/mimswap/MagicLP.sol

68:     bool internal _INITIALIZED_;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

### <a name="GAS-3"></a>[GAS-3] Cache array length outside of loop
If not cached, the solidity compiler will always read the length of the array during each iteration. That is, if it is a storage array, this is an extra sload operation (100 additional extra gas for each iteration except for the first) and if it is a memory array, this is an extra mload operation (3 additional gas for each iteration except for the first).

*Instances (7)*:
```solidity
File: src/blast/BlastOnboarding.sol

165:         for (uint256 i = 0; i < tokens.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboarding.sol)

```solidity
File: src/staking/LockingMultiRewards.sol

405:         for (uint256 i; i < users.length; ) {

547:         for (uint256 i; i < rewardTokens.length; ) {

561:         for (uint256 i; i < rewardTokens.length; ) {

575:         for (uint256 i; i < rewardTokens.length; ) {

580:             for (uint256 j; j < users.length; ) {

614:         for (uint256 i; i < rewardTokens.length; ) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/staking/LockingMultiRewards.sol)

### <a name="GAS-4"></a>[GAS-4] For Operations that will not overflow, you could use unchecked

*Instances (215)*:
```solidity
File: src/blast/BlastBox.sol

38:         address /*from*/,

39:         address /*to*/,

40:         uint256 /*amount*/,

41:         uint256 /*share*/

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastBox.sol)

```solidity
File: src/blast/BlastOnboarding.sol

105:             totals[token].locked += amount;

106:             balances[msg.sender][token].locked += amount;

108:             totals[token].unlocked += amount;

109:             balances[msg.sender][token].unlocked += amount;

112:         totals[token].total += amount;

118:         balances[msg.sender][token].total += amount;

124:         balances[msg.sender][token].unlocked -= amount;

125:         balances[msg.sender][token].locked += amount;

126:         totals[token].unlocked -= amount;

127:         totals[token].locked += amount;

133:         balances[msg.sender][token].unlocked -= amount;

134:         balances[msg.sender][token].total -= amount;

135:         totals[token].unlocked -= amount;

136:         totals[token].total -= amount;

165:         for (uint256 i = 0; i < tokens.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboarding.sol)

```solidity
File: src/blast/BlastOnboardingBoot.sol

15: uint256 constant FEE_RATE = 0.0005 ether; // 0.05%

16: uint256 constant K = 0.00025 ether; // 0.00025, 1.25% price fluctuation, similar to A2000 in curve

17: uint256 constant I = 0.998 ether; // 1 MIM = 0.998 USDB

18: uint256 constant USDB_TO_MIN = 1.002 ether; // 1 USDB = 1.002 MIM

156:         uint256 totalLocked = totals[MIM].locked + totals[USDB].locked;

162:         uint256 userLocked = balances[user][MIM].locked + balances[user][USDB].locked;

163:         return (userLocked * totalPoolShares) / totalLocked;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol)

```solidity
File: src/mimswap/MagicLP.sol

4:     SPDX-License-Identifier: Apache-2.0

63:     uint256 public constant MAX_I = 10 ** 36;

64:     uint256 public constant MAX_K = 10 ** 18;

65:     uint256 public constant MIN_LP_FEE_RATE = 1e14; // 0.01%

66:     uint256 public constant MAX_LP_FEE_RATE = 1e16; // 1%

125:         _BLOCK_TIMESTAMP_LAST_ = uint32(block.timestamp % 2 ** 32);

156:         return string(abi.encodePacked("MagicLP ", IERC20Metadata(_BASE_TOKEN_).symbol(), "/", IERC20Metadata(_QUOTE_TOKEN_).symbol()));

176:         receiveQuoteAmount = receiveQuoteAmount - DecimalMath.mulFloor(receiveQuoteAmount, lpFeeRate) - mtFee;

189:         receiveBaseAmount = receiveBaseAmount - DecimalMath.mulFloor(receiveBaseAmount, lpFeeRate) - mtFee;

198:         state.B0 = _BASE_TARGET_; // will be calculated in adjustedTarget

229:         return _BASE_TOKEN_.balanceOf(address(this)) - uint256(_BASE_RESERVE_);

233:         return _QUOTE_TOKEN_.balanceOf(address(this)) - uint256(_QUOTE_RESERVE_);

246:         uint256 baseInput = baseBalance - uint256(_BASE_RESERVE_);

269:         uint256 quoteInput = quoteBalance - uint256(_QUOTE_RESERVE_);

309:             uint256 quoteInput = quoteBalance - uint256(_QUOTE_RESERVE_);

315:             if (uint256(_BASE_RESERVE_) - baseBalance > receiveBaseAmount) {

331:             uint256 baseInput = baseBalance - uint256(_BASE_RESERVE_);

337:             if (uint256(_QUOTE_RESERVE_) - quoteBalance > receiveQuoteAmount) {

366:         baseInput = baseBalance - baseReserve;

367:         quoteInput = quoteBalance - quoteReserve;

394:             shares -= 1001;

402:             _BASE_TARGET_ = (uint256(_BASE_TARGET_) + DecimalMath.mulFloor(uint256(_BASE_TARGET_), mintRatio)).toUint112();

403:             _QUOTE_TARGET_ = (uint256(_QUOTE_TARGET_) + DecimalMath.mulFloor(uint256(_QUOTE_TARGET_), mintRatio)).toUint112();

435:         baseAmount = (baseBalance * shareAmount) / totalShares;

436:         quoteAmount = (quoteBalance * shareAmount) / totalShares;

438:         _BASE_TARGET_ = uint112(uint256(_BASE_TARGET_) - (uint256(_BASE_TARGET_) * shareAmount).divCeil(totalShares));

439:         _QUOTE_TARGET_ = uint112(uint256(_QUOTE_TARGET_) - (uint256(_QUOTE_TARGET_) * shareAmount).divCeil(totalShares));

513:             _BASE_TARGET_ = uint112((uint256(_BASE_TARGET_) * baseBalance) / uint256(_BASE_RESERVE_));

517:             _QUOTE_TARGET_ = uint112((uint256(_QUOTE_TARGET_) * quoteBalance) / uint256(_QUOTE_RESERVE_));

546:         uint32 blockTimestamp = uint32(block.timestamp % 2 ** 32);

547:         uint32 timeElapsed = blockTimestamp - _BLOCK_TIMESTAMP_LAST_;

553:                 _BASE_PRICE_CUMULATIVE_LAST_ += getMidPrice() * timeElapsed;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/mimswap/auxiliary/FeeRateModel.sol

4:     SPDX-License-Identifier: Apache-2.0

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/auxiliary/FeeRateModel.sol)

```solidity
File: src/mimswap/auxiliary/FeeRateModelImpl.sol

10:         address /*pool*/,

11:         address /*trader*/,

15:         return (lpFeeRate - mtFeeRate, mtFeeRate);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/auxiliary/FeeRateModelImpl.sol)

```solidity
File: src/mimswap/libraries/DecimalMath.sol

4:     SPDX-License-Identifier: Apache-2.0

20:     uint256 internal constant ONE = 10 ** 18;

21:     uint256 internal constant ONE2 = 10 ** 36;

24:         return (target * d) / ONE;

28:         return (target * d).divCeil(ONE);

32:         return (target * ONE) / d;

36:         return (target * ONE).divCeil(d);

40:         return ONE2 / target;

49:             return 10 ** 18;

53:             uint p = powFloor(target, e / 2);

54:             p = (p * p) / ONE;

56:                 p = (p * target) / ONE;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/DecimalMath.sol)

```solidity
File: src/mimswap/libraries/Math.sol

4:     SPDX-License-Identifier: Apache-2.0

20:         uint256 quotient = a / b;

21:         uint256 remainder = a - quotient * b;

23:             return quotient + 1;

30:         uint256 z = x / 2 + 1;

34:             z = (x / z + z) / 2;

41:         res = (1-k)i(V1-V2)+ikV0*V0(1/V2-1/V1)

42:         let V1-V2=delta

43:         res = i*delta*(1-k+k(V0^2/V1/V2))

45:         i is the price of V-res trading pair

56:         uint256 fairAmount = i * (V1 - V2); // i*delta

59:             return fairAmount / DecimalMath.ONE;

62:         uint256 V0V0V1V2 = DecimalMath.divFloor((V0 * V0) / V1, V2);

63:         uint256 penalty = DecimalMath.mulFloor(k, V0V0V1V2); // k(V0^2/V1/V2)

64:         return (((DecimalMath.ONE - k) + penalty) * fairAmount) / DecimalMath.ONE2;

69:         i*deltaB = (Q2-Q1)*(1-k+kQ0^2/Q1/Q2)

72:         i is the price of delta-V trading pair

81:             return V1 + DecimalMath.mulFloor(i, delta);

93:         uint256 ki = (4 * k) * i;

96:         } else if ((ki * delta) / ki == delta) {

97:             _sqrt = sqrt(((ki * delta) / V1) + DecimalMath.ONE2);

99:             _sqrt = sqrt(((ki / V1) * delta) + DecimalMath.ONE2);

101:         uint256 premium = DecimalMath.divFloor(_sqrt - DecimalMath.ONE, k * 2) + DecimalMath.ONE;

108:         i*deltaB = (Q2-Q1)*(1-k+kQ0^2/Q1/Q2)

111:         aQ2^2 + bQ2 + c = 0, where

112:         a=1-k

113:         -b=(1-k)Q1-kQ0^2/Q1+i*deltaB

114:         c=-kQ0^2 

115:         and Q2=(-b+sqrt(b^2+4(1-k)kQ0^2))/2(1-k)

120:         return |Q1-Q2|

123:         the input ideltaB is actually -ideltaB in the equation

125:         i is the price of delta-V trading pair

152:             uint256 idelta = i * delta;

155:             } else if ((idelta * V1) / idelta == V1) {

156:                 temp = (idelta * V1) / (V0 * V0);

158:                 temp = (((delta * V1) / V0) * i) / V0;

160:             return (V1 * temp) / (temp + DecimalMath.ONE);

170:         uint256 part2 = (((k * V0) / V1) * V0) + (i * delta); // kQ0^2/Q1-i*deltaB

171:         uint256 bAbs = (DecimalMath.ONE - k) * V1; // (1-k)Q1

175:             bAbs = bAbs - part2;

178:             bAbs = part2 - bAbs;

181:         bAbs = bAbs / DecimalMath.ONE;

184:         uint256 squareRoot = DecimalMath.mulFloor((DecimalMath.ONE - k) * 4, DecimalMath.mulFloor(k, V0) * V0); // 4(1-k)kQ0^2

185:         squareRoot = sqrt((bAbs * bAbs) + squareRoot); // sqrt(b*b+4(1-k)kQ0*Q0)

188:         uint256 denominator = (DecimalMath.ONE - k) * 2; // 2(1-k)

191:             numerator = squareRoot - bAbs;

196:             numerator = bAbs + squareRoot;

203:             return V1 - V2;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/Math.sol)

```solidity
File: src/mimswap/libraries/PMMPricing.sol

4:     SPDX-License-Identifier: Apache-2.0

46:             uint256 backToOnePayBase = state.B0 - state.B;

47:             uint256 backToOneReceiveQuote = state.Q - state.Q0;

65:                 receiveQuoteAmount = backToOneReceiveQuote + _ROneSellBaseToken(state, payBaseAmount - backToOnePayBase);

84:             uint256 backToOnePayQuote = state.Q0 - state.Q;

85:             uint256 backToOneReceiveBase = state.B - state.B0;

96:                 receiveBaseAmount = backToOneReceiveBase + _ROneSellQuoteToken(state, payQuoteAmount - backToOnePayQuote);

111:             uint256 // receiveQuoteToken

126:             uint256 // receiveBaseToken

141:             uint256 // receiveBaseToken

144:         return Math._GeneralIntegrate(state.Q0, state.Q + payQuoteAmount, state.Q, DecimalMath.reciprocalFloor(state.i), state.K);

154:             uint256 // receiveQuoteToken

169:             uint256 // receiveQuoteToken

172:         return Math._GeneralIntegrate(state.B0, state.B + payBaseAmount, state.B, state.i, state.K);

182:             uint256 // receiveBaseToken

192:             state.Q0 = Math._SolveQuadraticFunctionForTarget(state.Q, state.B - state.B0, state.i, state.K);

196:                 state.Q - state.Q0,

205:             uint256 R = DecimalMath.divFloor((state.Q0 * state.Q0) / state.Q, state.Q);

206:             R = (DecimalMath.ONE - state.K) + DecimalMath.mulFloor(state.K, R);

209:             uint256 R = DecimalMath.divFloor((state.B0 * state.B0) / state.B, state.B);

210:             R = (DecimalMath.ONE - state.K) + DecimalMath.mulFloor(state.K, R);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/PMMPricing.sol)

```solidity
File: src/mimswap/periphery/Factory.sol

131:         _pools[poolIndex] = _pools[_pools.length - 1];

138:         _userPools[userPoolIndex] = _userPools[_userPools.length - 1];

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Factory.sol)

```solidity
File: src/mimswap/periphery/Router.sol

109:         shares -= 1001;

119:         uint256 baseBalance = IMagicLP(lp)._BASE_TOKEN_().balanceOf(address(lp)) + baseInAmount;

120:         uint256 quoteBalance = IMagicLP(lp)._QUOTE_TOKEN_().balanceOf(address(lp)) + quoteInAmount;

122:         baseInAmount = baseBalance - baseReserve;

123:         quoteInAmount = quoteBalance - quoteReserve;

146:             shares -= 1001;

221:             refundTo.safeTransferETH(msg.value - wethAdjustedAmount);

257:         baseAmountOut = (baseBalance * sharesIn) / totalShares;

258:         quoteAmountOut = (quoteBalance * sharesIn) / totalShares;

375:         uint256 lastLpIndex = path.length - 1;

515:         uint256 baseBalance = IMagicLP(lp)._BASE_TOKEN_().balanceOf(address(lp)) + baseInAmount;

516:         uint256 quoteBalance = IMagicLP(lp)._QUOTE_TOKEN_().balanceOf(address(lp)) + quoteInAmount;

518:         baseInAmount = baseBalance - baseReserve;

519:         quoteInAmount = quoteBalance - quoteReserve;

542:         uint256 iterations = path.length - 1; // Subtract by one as last swap is done separately

547:                 IMagicLP(path[i]).sellBase(address(path[i + 1]));

550:                 IMagicLP(path[i]).sellQuote(address(path[i + 1]));

556:                 ++i;

602:         if (quoteDecimals - baseDecimals > MAX_BASE_QUOTE_DECIMALS_DIFFERENCE) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Router.sol)

```solidity
File: src/oracles/aggregators/MagicLpAggregator.sol

38:         uint256 baseAnswerNomalized = uint256(baseOracle.latestAnswer()) * (10 ** (WAD - baseOracle.decimals()));

39:         uint256 quoteAnswerNormalized = uint256(quoteOracle.latestAnswer()) * (10 ** (WAD - quoteOracle.decimals()));

43:         baseReserve = baseReserve * (10 ** (WAD - baseDecimals));

44:         quoteReserve = quoteReserve * (10 ** (WAD - quoteDecimals));

45:         return int256(minAnswer * (baseReserve + quoteReserve) / pair.totalSupply());

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/oracles/aggregators/MagicLpAggregator.sol)

```solidity
File: src/staking/LockingMultiRewards.sol

100:     uint256 public lockedSupply; // all locked boosted deposits

101:     uint256 public unlockedSupply; // all unlocked unboosted deposits

102:     uint256 public minLockAmount; // minimum amount allowed to lock

103:     uint256 public stakingTokenBalance; // total staking token balance

144:         maxLocks = _lockDuration / _rewardsDuration;

162:         _balances[msg.sender].unlocked -= amount;

163:         unlockedSupply -= amount;

177:         _balances[msg.sender].unlocked -= amount;

178:         unlockedSupply -= amount;

181:         stakingTokenBalance -= amount;

204:         return _rewardData[rewardToken].rewardRate * rewardsDuration;

236:         return unlockedSupply + ((lockedSupply * lockingBoostMultiplerInBips) / BIPS);

241:         return bal.unlocked + ((bal.locked * lockingBoostMultiplerInBips) / BIPS);

254:         return nextEpoch() + lockDuration;

258:         return (block.timestamp / rewardsDuration) * rewardsDuration;

262:         return epoch() + rewardsDuration;

266:         return nextEpoch() - block.timestamp;

282:         uint256 timeElapsed = lastTimeRewardApplicable_ - _rewardData[rewardToken].lastUpdateTime;

283:         uint256 pendingRewardsPerToken = (timeElapsed * _rewardData[rewardToken].rewardRate * 1e18) / totalSupply_;

285:         return _rewardData[rewardToken].rewardPerTokenStored + pendingRewardsPerToken;

293:         uint256 pendingUserRewardsPerToken = rewardPerToken_ - userRewardPerTokenPaid[user][rewardToken];

294:         return ((balance_ * pendingUserRewardsPerToken) / 1e18) + rewards[user][rewardToken];

326:         if (tokenAddress == stakingToken && tokenAmount > stakingToken.balanceOf(address(this)) - stakingTokenBalance) {

372:         uint256 _remainingRewardTime = _nextEpoch - block.timestamp;

380:             amount += _remainingRewardTime * reward.rewardRate;

388:         reward.rewardRate = amount / _remainingRewardTime;

427:             uint256 lastIndex = locks.length - 1;

441:             unlockedSupply += amount;

442:             lockedSupply -= amount;

444:             bal.unlocked += amount;

445:             bal.locked -= amount;

450:                 ++i;

465:         stakingTokenBalance += amount;

472:             _balances[account].unlocked += amount;

473:             unlockedSupply += amount;

485:         bal.locked += amount;

486:         lockedSupply += amount;

505:                 ++lockCount;

510:             _userLocks[user][_lastLockIndex].amount += amount;

533:         _rewardData[token_].lastUpdateTime = uint248(lastTimeRewardApplicable_); // safe to cast as this will never overflow

550:                 ++i;

566:                 ++i;

585:                     ++j;

590:                 ++i;

642:                     item.amount += rewardAmount;

654:                 ++i;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/staking/LockingMultiRewards.sol)

### <a name="GAS-5"></a>[GAS-5] Avoid contract existence checks by using low level calls
Prior to 0.8.10 the compiler inserted extra code, including `EXTCODESIZE` (**100 gas**), to check for contract existence for external function calls. In more recent solidity versions, the compiler will not insert these checks if the external call has a return value. Similar behavior can be achieved in earlier versions by using low-level calls, since low level calls never check for contract existence

*Instances (25)*:
```solidity
File: src/mimswap/MagicLP.sol

229:         return _BASE_TOKEN_.balanceOf(address(this)) - uint256(_BASE_RESERVE_);

233:         return _QUOTE_TOKEN_.balanceOf(address(this)) - uint256(_QUOTE_RESERVE_);

245:         uint256 baseBalance = _BASE_TOKEN_.balanceOf(address(this));

262:         _setReserve(baseBalance, _QUOTE_TOKEN_.balanceOf(address(this)));

268:         uint256 quoteBalance = _QUOTE_TOKEN_.balanceOf(address(this));

285:         _setReserve(_BASE_TOKEN_.balanceOf(address(this)), quoteBalance);

298:         uint256 baseBalance = _BASE_TOKEN_.balanceOf(address(this));

299:         uint256 quoteBalance = _QUOTE_TOKEN_.balanceOf(address(this));

361:         uint256 baseBalance = _BASE_TOKEN_.balanceOf(address(this));

362:         uint256 quoteBalance = _QUOTE_TOKEN_.balanceOf(address(this));

431:         uint256 baseBalance = _BASE_TOKEN_.balanceOf(address(this));

432:         uint256 quoteBalance = _QUOTE_TOKEN_.balanceOf(address(this));

505:         uint256 baseBalance = _BASE_TOKEN_.balanceOf(address(this));

506:         uint256 quoteBalance = _QUOTE_TOKEN_.balanceOf(address(this));

529:         baseBalance = _BASE_TOKEN_.balanceOf(address(this));

530:         quoteBalance = _QUOTE_TOKEN_.balanceOf(address(this));

568:         uint256 baseBalance = _BASE_TOKEN_.balanceOf(address(this));

569:         uint256 quoteBalance = _QUOTE_TOKEN_.balanceOf(address(this));

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/mimswap/periphery/Router.sol

119:         uint256 baseBalance = IMagicLP(lp)._BASE_TOKEN_().balanceOf(address(lp)) + baseInAmount;

120:         uint256 quoteBalance = IMagicLP(lp)._QUOTE_TOKEN_().balanceOf(address(lp)) + quoteInAmount;

252:         uint256 baseBalance = IMagicLP(lp)._BASE_TOKEN_().balanceOf(address(lp));

253:         uint256 quoteBalance = IMagicLP(lp)._QUOTE_TOKEN_().balanceOf(address(lp));

515:         uint256 baseBalance = IMagicLP(lp)._BASE_TOKEN_().balanceOf(address(lp)) + baseInAmount;

516:         uint256 quoteBalance = IMagicLP(lp)._QUOTE_TOKEN_().balanceOf(address(lp)) + quoteInAmount;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Router.sol)

```solidity
File: src/staking/LockingMultiRewards.sol

326:         if (tokenAddress == stakingToken && tokenAmount > stakingToken.balanceOf(address(this)) - stakingTokenBalance) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/staking/LockingMultiRewards.sol)

### <a name="GAS-6"></a>[GAS-6] Functions guaranteed to revert when called by normal users can be marked `payable`
If a function modifier such as `onlyOwner` is used, the function will revert if a normal user tries to pay the function. Marking the function as `payable` will lower the gas cost for legitimate callers because the compiler will not include checks for whether a payment was provided.

*Instances (51)*:
```solidity
File: src/blast/BlastBox.sol

52:     function claimGasYields() external onlyOperators returns (uint256) {

56:     function claimTokenYields(address token_) external onlyOperators returns (uint256 amount) {

68:     function callBlastPrecompile(bytes calldata data) external onlyOwner {

72:     function setFeeTo(address feeTo_) external onlyOwner {

81:     function setTokenEnabled(address token, bool enabled) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastBox.sol)

```solidity
File: src/blast/BlastGovernor.sol

28:     function claimNativeYields(address contractAddress) external onlyOperators returns (uint256) {

32:     function claimMaxGasYields(address contractAddress) external onlyOperators returns (uint256) {

40:     function setFeeTo(address _feeTo) external onlyOwner {

49:     function callBlastPrecompile(bytes calldata data) external onlyOwner {

53:     function execute(address to, uint256 value, bytes calldata data) external onlyOwner returns (bool success, bytes memory result) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastGovernor.sol)

```solidity
File: src/blast/BlastMagicLP.sol

47:     function claimGasYields() external onlyClones onlyImplementationOperators returns (uint256) {

53:     function claimTokenYields() external onlyClones onlyImplementationOperators returns (uint256 token0Amount, uint256 token1Amount) {

64:     function updateTokenClaimables() external onlyClones onlyImplementationOperators {

72:     function callBlastPrecompile(bytes calldata data) external onlyClones onlyImplementationOwner {

80:     function setFeeTo(address feeTo_) external onlyImplementation onlyImplementationOwner {

89:     function setOperator(address operator, bool status) external onlyImplementation onlyImplementationOwner {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastMagicLP.sol)

```solidity
File: src/blast/BlastOnboarding.sol

101:     function deposit(address token, uint256 amount, bool lock_) external whenNotPaused onlyState(State.Opened) onlySupportedTokens(token) {

123:     function lock(address token, uint256 amount) external whenNotPaused onlyState(State.Opened) onlySupportedTokens(token) {

132:     function withdraw(address token, uint256 amount) external whenNotPaused onlySupportedTokens(token) {

147:     function setFeeTo(address feeTo_) external onlyOwner {

156:     function callBlastPrecompile(bytes calldata data) external onlyOwner {

160:     function claimGasYields() external onlyOwner returns (uint256) {

164:     function claimTokenYields(address[] memory tokens) external onlyOwner {

175:     function setTokenSupported(address token, bool supported) external onlyOwner {

185:     function setCap(address token, uint256 cap) external onlyOwner onlySupportedTokens(token) {

190:     function setBootstrapper(address bootstrapper_) external onlyOwner {

195:     function open() external onlyOwner onlyState(State.Idle) {

200:     function close() external onlyOwner onlyState(State.Opened) {

205:     function rescue(address token, address to, uint256 amount) external onlyOwner {

214:     function pause() external onlyOwner {

218:     function unpause() external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboarding.sol)

```solidity
File: src/blast/BlastOnboardingBoot.sol

96:     function bootstrap(uint256 minAmountOut) external onlyOwner onlyState(State.Closed) returns (address, address, uint256) {

129:     function initialize(Router _router) external onlyOwner {

137:     function setStaking(LockingMultiRewards _staking) external onlyOwner {

146:     function setReady(bool _ready) external onlyOwner onlyState(State.Closed) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol)

```solidity
File: src/blast/BlastTokenRegistry.sol

14:     function setNativeYieldTokenEnabled(address token, bool enabled) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastTokenRegistry.sol)

```solidity
File: src/mimswap/MagicLP.sol

461:     function rescue(address token, address to, uint256 amount) external onlyImplementationOwner {

504:     function ratioSync() external nonReentrant onlyImplementationOwner {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/mimswap/auxiliary/FeeRateModel.sol

46:     function setMaintainer(address maintainer_) external onlyOwner {

57:     function setImplementation(address implementation_) public onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/auxiliary/FeeRateModel.sol)

```solidity
File: src/mimswap/periphery/Factory.sol

96:     function setLpImplementation(address implementation_) external onlyOwner {

105:     function setMaintainerFeeRateModel(IFeeRateModel maintainerFeeRateModel_) external onlyOwner {

116:     function addPool(address creator, address baseToken, address quoteToken, address pool) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Factory.sol)

```solidity
File: src/staking/LockingMultiRewards.sol

300:     function addReward(address rewardToken) public onlyOwner {

317:     function setMinLockAmount(uint256 _minLockAmount) external onlyOwner {

324:     function recover(address tokenAddress, uint256 tokenAmount) external onlyOwner {

337:     function pause() external onlyOwner {

341:     function unpause() external onlyOwner {

349:     function stakeFor(address account, uint256 amount, bool lock_) external onlyOperators {

361:     function notifyRewardAmount(address rewardToken, uint256 amount, uint minRemainingTime) public onlyOperators {

397:     function processExpiredLocks(address[] memory users, uint256[] calldata lockIndexes) external onlyOperators {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/staking/LockingMultiRewards.sol)

### <a name="GAS-7"></a>[GAS-7] `++i` costs less gas compared to `i++` or `i += 1` (same for `--i` vs `i--` or `i -= 1`)
Pre-increments and pre-decrements are cheaper.

For a `uint256 i` variable, the following is true with the Optimizer enabled at 10k:

**Increment:**

- `i += 1` is the most expensive form
- `i++` costs 6 gas less than `i += 1`
- `++i` costs 5 gas less than `i++` (11 gas less than `i += 1`)

**Decrement:**

- `i -= 1` is the most expensive form
- `i--` costs 11 gas less than `i -= 1`
- `--i` costs 5 gas less than `i--` (16 gas less than `i -= 1`)

Note that post-increments (or post-decrements) return the old value before incrementing or decrementing, hence the name *post-increment*:

```solidity
uint i = 1;  
uint j = 2;
require(j == i++, "This will be false as i is incremented after the comparison");
```
  
However, pre-increments (or pre-decrements) return the new value:
  
```solidity
uint i = 1;  
uint j = 2;
require(j == ++i, "This will be true as i is incremented before the comparison");
```

In the pre-increment case, the compiler has to create a temporary variable (when used) for returning `1` instead of `2`.

Consider using pre-increments and pre-decrements where they are relevant (meaning: not where post-increments/decrements logic are relevant).

*Saves 5 gas per instance*

*Instances (1)*:
```solidity
File: src/blast/BlastOnboarding.sol

165:         for (uint256 i = 0; i < tokens.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboarding.sol)

### <a name="GAS-8"></a>[GAS-8] Using `private` rather than `public` for constants, saves gas
If needed, the values can be read from the verified contract source code, or if there are multiple values there can be a single getter function that [returns a tuple](https://github.com/code-423n4/2022-08-frax/blob/90f55a9ce4e25bceed3a74290b854341d8de6afa/src/contracts/FraxlendPair.sol#L156-L178) of the values of all currently-public constants. Saves **3406-3606 gas** in deployment gas due to the compiler not having to create non-payable getter functions for deployment calldata, not having to store the bytes of the value outside of where it's used, and not adding another entry to the method ID table

*Instances (8)*:
```solidity
File: src/blast/libraries/BlastPoints.sol

7:     address public constant BLAST_POINTS_OPERATOR = 0xD1025F1359422Ca16D9084908d629E0dBa60ff28;

8:     IBlastPoints public constant BLAST_POINTS = IBlastPoints(0x2536FE9ab3F511540F2f9e2eC2A805005C3Dd800);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/libraries/BlastPoints.sol)

```solidity
File: src/mimswap/MagicLP.sol

63:     uint256 public constant MAX_I = 10 ** 36;

64:     uint256 public constant MAX_K = 10 ** 18;

65:     uint256 public constant MIN_LP_FEE_RATE = 1e14; // 0.01%

66:     uint256 public constant MAX_LP_FEE_RATE = 1e16; // 1%

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/mimswap/periphery/Router.sol

31:     uint256 public constant MAX_BASE_QUOTE_DECIMALS_DIFFERENCE = 12;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Router.sol)

```solidity
File: src/oracles/aggregators/MagicLpAggregator.sol

16:     uint256 public constant WAD = 18;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/oracles/aggregators/MagicLpAggregator.sol)

### <a name="GAS-9"></a>[GAS-9] Use shift right/left instead of division/multiplication if possible
While the `DIV` / `MUL` opcode uses 5 gas, the `SHR` / `SHL` opcode only uses 3 gas. Furthermore, beware that Solidity's division operation also includes a division-by-0 prevention which is bypassed using shifting. Eventually, overflow checks are never performed for shift operations as they are done for arithmetic operations. Instead, the result is always truncated, so the calculation can be unchecked in Solidity version `0.8+`
- Use `>> 1` instead of `/ 2`
- Use `>> 2` instead of `/ 4`
- Use `<< 3` instead of `* 8`
- ...
- Use `>> 5` instead of `/ 2^5 == / 32`
- Use `<< 6` instead of `* 2^6 == * 64`

TL;DR:
- Shifting left by N is like multiplying by 2^N (Each bits to the left is an increased power of 2)
- Shifting right by N is like dividing by 2^N (Each bits to the right is a decreased power of 2)

*Saves around 2 gas + 20 for unchecked per instance*

*Instances (7)*:
```solidity
File: src/mimswap/libraries/DecimalMath.sol

53:             uint p = powFloor(target, e / 2);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/DecimalMath.sol)

```solidity
File: src/mimswap/libraries/Math.sol

30:         uint256 z = x / 2 + 1;

34:             z = (x / z + z) / 2;

101:         uint256 premium = DecimalMath.divFloor(_sqrt - DecimalMath.ONE, k * 2) + DecimalMath.ONE;

115:         and Q2=(-b+sqrt(b^2+4(1-k)kQ0^2))/2(1-k)

184:         uint256 squareRoot = DecimalMath.mulFloor((DecimalMath.ONE - k) * 4, DecimalMath.mulFloor(k, V0) * V0); // 4(1-k)kQ0^2

188:         uint256 denominator = (DecimalMath.ONE - k) * 2; // 2(1-k)

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/Math.sol)

### <a name="GAS-10"></a>[GAS-10] Increments/decrements can be unchecked in for-loops
In Solidity 0.8+, there's a default overflow check on unsigned integers. It's possible to uncheck this in for-loops and save some gas at each iteration, but at the cost of some code readability, as this uncheck cannot be made inline.

[ethereum/solidity#10695](https://github.com/ethereum/solidity/issues/10695)

The change would be:

```diff
- for (uint256 i; i < numIterations; i++) {
+ for (uint256 i; i < numIterations;) {
 // ...  
+   unchecked { ++i; }
}  
```

These save around **25 gas saved** per instance.

The same can be applied with decrements (which should use `break` when `i == 0`).

The risk of overflow is non-existent for `uint256`.

*Instances (1)*:
```solidity
File: src/blast/BlastOnboarding.sol

165:         for (uint256 i = 0; i < tokens.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboarding.sol)

### <a name="GAS-11"></a>[GAS-11] Use != 0 instead of > 0 for unsigned integer comparison

*Instances (32)*:
```solidity
File: src/blast/BlastBox.sol

3: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastBox.sol)

```solidity
File: src/blast/BlastDapp.sol

2: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastDapp.sol)

```solidity
File: src/blast/BlastGovernor.sol

2: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastGovernor.sol)

```solidity
File: src/blast/BlastMagicLP.sol

3: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastMagicLP.sol)

```solidity
File: src/blast/BlastOnboarding.sol

2: pragma solidity >=0.8.0;

114:         if (caps[token] > 0 && totals[token].total > caps[token]) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboarding.sol)

```solidity
File: src/blast/BlastOnboardingBoot.sol

2: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol)

```solidity
File: src/blast/BlastTokenRegistry.sol

2: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastTokenRegistry.sol)

```solidity
File: src/blast/BlastWrappers.sol

2: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastWrappers.sol)

```solidity
File: src/blast/libraries/BlastPoints.sol

2: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/libraries/BlastPoints.sol)

```solidity
File: src/blast/libraries/BlastYields.sol

2: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/libraries/BlastYields.sol)

```solidity
File: src/mimswap/MagicLP.sol

8: pragma solidity >=0.8.0;

294:         if (data.length > 0) {

395:         } else if (baseReserve > 0 && quoteReserve > 0) {

450:         if (data.length > 0) {

549:         if (timeElapsed > 0 && _BASE_RESERVE_ != 0 && _QUOTE_RESERVE_ != 0) {

582:         if (amount > 0) {

588:         if (amount > 0) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/mimswap/auxiliary/FeeRateModel.sol

8: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/auxiliary/FeeRateModel.sol)

```solidity
File: src/mimswap/auxiliary/FeeRateModelImpl.sol

2: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/auxiliary/FeeRateModelImpl.sol)

```solidity
File: src/mimswap/libraries/DecimalMath.sol

7: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/DecimalMath.sol)

```solidity
File: src/mimswap/libraries/Math.sol

8: pragma solidity >=0.8.0;

22:         if (remainder > 0) {

40:         require V0>=V1>=V2>0

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/Math.sol)

```solidity
File: src/mimswap/libraries/PMMPricing.sol

8: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/PMMPricing.sol)

```solidity
File: src/mimswap/periphery/Factory.sol

2: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Factory.sol)

```solidity
File: src/mimswap/periphery/Router.sol

2: pragma solidity >=0.8.0;

147:         } else if (baseReserve > 0 && quoteReserve > 0) {

527:             if (quoteReserve > 0 && baseReserve > 0) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Router.sol)

```solidity
File: src/oracles/aggregators/MagicLpAggregator.sol

2: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/oracles/aggregators/MagicLpAggregator.sol)

```solidity
File: src/staking/LockingMultiRewards.sol

2: pragma solidity >=0.8.0;

636:                     if (amount > 0) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/staking/LockingMultiRewards.sol)

### <a name="GAS-12"></a>[GAS-12] WETH address definition can be use directly
WETH is a wrap Ether contract with a specific address in the Ethereum network, giving the option to define it may cause false recognition, it is healthier to define it directly.

    Advantages of defining a specific contract directly:
    
    It saves gas,
    Prevents incorrect argument definition,
    Prevents execution on a different chain and re-signature issues,
    WETH Address : 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2

*Instances (1)*:
```solidity
File: src/mimswap/periphery/Router.sol

33:     IWETH public immutable weth;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Router.sol)


## Non Critical Issues


| |Issue|Instances|
|-|:-|:-:|
| [NC-1](#NC-1) | Use `string.concat()` or `bytes.concat()` instead of `abi.encodePacked` | 2 |
| [NC-2](#NC-2) | Constants should be in CONSTANT_CASE | 2 |
| [NC-3](#NC-3) | `constant`s should be defined rather than using magic numbers | 28 |
| [NC-4](#NC-4) | Control structures do not follow the Solidity Style Guide | 23 |
| [NC-5](#NC-5) | Critical Changes Should Use Two-step Procedure | 1 |
| [NC-6](#NC-6) | Default Visibility for constants | 8 |
| [NC-7](#NC-7) | Functions should not be longer than 50 lines | 152 |
| [NC-8](#NC-8) | Change uint to uint256 | 2 |
| [NC-9](#NC-9) | Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor | 5 |
| [NC-10](#NC-10) | Consider using named mappings | 3 |
| [NC-11](#NC-11) | `address`s shouldn't be hard-coded | 5 |
| [NC-12](#NC-12) | Owner can renounce while system is paused | 4 |
| [NC-13](#NC-13) | Take advantage of Custom Error's return value property | 105 |
| [NC-14](#NC-14) | Use scientific notation (e.g. `1e18`) rather than exponentiation (e.g. `10**18`) | 5 |
| [NC-15](#NC-15) | Avoid the use of sensitive terms | 4 |
| [NC-16](#NC-16) | Use Underscores for Number Literals (add an underscore every 3 digits) | 13 |
| [NC-17](#NC-17) | Constants should be defined rather than using magic numbers | 1 |
| [NC-18](#NC-18) | Variables need not be initialized to zero | 2 |
### <a name="NC-1"></a>[NC-1] Use `string.concat()` or `bytes.concat()` instead of `abi.encodePacked`
Solidity version 0.8.4 introduces `bytes.concat()` (vs `abi.encodePacked(<bytes>,<bytes>)`)

Solidity version 0.8.12 introduces `string.concat()` (vs `abi.encodePacked(<str>,<str>), which catches concatenation errors (in the event of a `bytes` data mixed in the concatenation)`)

*Instances (2)*:
```solidity
File: src/mimswap/MagicLP.sol

156:         return string(abi.encodePacked("MagicLP ", IERC20Metadata(_BASE_TOKEN_).symbol(), "/", IERC20Metadata(_QUOTE_TOKEN_).symbol()));

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/mimswap/periphery/Factory.sol

163:         return keccak256(abi.encodePacked(sender_, implementation, baseToken_, quoteToken_, lpFeeRate_, i_, k_));

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Factory.sol)

### <a name="NC-2"></a>[NC-2] Constants should be in CONSTANT_CASE
For `constant` variable names, each word should use all capital letters, with underscores separating each word (CONSTANT_CASE)

*Instances (2)*:
```solidity
File: src/blast/BlastOnboardingBoot.sol

17: uint256 constant I = 0.998 ether; // 1 MIM = 0.998 USDB

18: uint256 constant USDB_TO_MIN = 1.002 ether; // 1 USDB = 1.002 MIM

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol)

### <a name="NC-3"></a>[NC-3] `constant`s should be defined rather than using magic numbers
Even [assembly](https://github.com/code-423n4/2022-05-opensea-seaport/blob/9d7ce4d08bf3c3010304a0476a785c70c0e90ae7/contracts/lib/TokenTransferrer.sol#L35-L39) can benefit from using readable constants instead of hex/numeric literals

*Instances (28)*:
```solidity
File: src/blast/BlastOnboardingBoot.sol

117:         staking = new LockingMultiRewards(pool, 30_000, 7 days, 13 weeks, address(this));

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol)

```solidity
File: src/mimswap/MagicLP.sol

3:     Copyright 2020 DODO ZOO.

125:         _BLOCK_TIMESTAMP_LAST_ = uint32(block.timestamp % 2 ** 32);

389:             if (shares <= 2001) {

393:             _mint(address(0), 1001);

394:             shares -= 1001;

546:         uint32 blockTimestamp = uint32(block.timestamp % 2 ** 32);

594:         if (amount <= 1000) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/mimswap/auxiliary/FeeRateModel.sol

3:     Copyright 2020 DODO ZOO.

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/auxiliary/FeeRateModel.sol)

```solidity
File: src/mimswap/auxiliary/FeeRateModelImpl.sol

14:         mtFeeRate = Math.divCeil(lpFeeRate, 2);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/auxiliary/FeeRateModelImpl.sol)

```solidity
File: src/mimswap/libraries/DecimalMath.sol

3:     Copyright 2020 DODO ZOO.

49:             return 10 ** 18;

53:             uint p = powFloor(target, e / 2);

55:             if (e % 2 == 1) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/DecimalMath.sol)

```solidity
File: src/mimswap/libraries/Math.sol

3:     Copyright 2020 DODO ZOO.

30:         uint256 z = x / 2 + 1;

34:             z = (x / z + z) / 2;

101:         uint256 premium = DecimalMath.divFloor(_sqrt - DecimalMath.ONE, k * 2) + DecimalMath.ONE;

184:         uint256 squareRoot = DecimalMath.mulFloor((DecimalMath.ONE - k) * 4, DecimalMath.mulFloor(k, V0) * V0); // 4(1-k)kQ0^2

188:         uint256 denominator = (DecimalMath.ONE - k) * 2; // 2(1-k)

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/Math.sol)

```solidity
File: src/mimswap/libraries/PMMPricing.sol

3:     Copyright 2020 DODO ZOO.

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/PMMPricing.sol)

```solidity
File: src/mimswap/periphery/Router.sol

85:             _validateDecimals(IERC20Metadata(token).decimals(), 18);

105:         if (shares <= 2001) {

109:         shares -= 1001;

142:             if (shares <= 2001) {

146:             shares -= 1001;

590:         if (pathLength > 256) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Router.sol)

```solidity
File: src/oracles/aggregators/MagicLpAggregator.sol

30:         return 18;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/oracles/aggregators/MagicLpAggregator.sol)

### <a name="NC-4"></a>[NC-4] Control structures do not follow the Solidity Style Guide
See the [control structures](https://docs.soliditylang.org/en/latest/style-guide.html#control-structures) section of the Solidity Style Guide

*Instances (23)*:
```solidity
File: src/blast/BlastGovernor.sol

41:         if(_feeTo == address(0)) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastGovernor.sol)

```solidity
File: src/blast/BlastOnboardingBoot.sol

26:     IFactory public factory;

131:         factory = IFactory(router.factory());

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol)

```solidity
File: src/blast/BlastWrappers.sol

31:         IFeeRateModel maintainerFeeRateModel_,

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastWrappers.sol)

```solidity
File: src/mimswap/MagicLP.sol

4:     SPDX-License-Identifier: Apache-2.0

79:     IFeeRateModel public _MT_FEE_RATE_MODEL_;

124:         _MT_FEE_RATE_MODEL_ = IFeeRateModel(mtFeeRateModel);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/mimswap/auxiliary/FeeRateModel.sol

4:     SPDX-License-Identifier: Apache-2.0

39:         return IFeeRateImpl(implementation).getFeeRate(msg.sender, trader, lpFeeRate);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/auxiliary/FeeRateModel.sol)

```solidity
File: src/mimswap/libraries/DecimalMath.sol

4:     SPDX-License-Identifier: Apache-2.0

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/DecimalMath.sol)

```solidity
File: src/mimswap/libraries/Math.sol

4:     SPDX-License-Identifier: Apache-2.0

118:         if deltaBSig=true, then Q2>Q1, user sell Q and receive B

119:         if deltaBSig=false, then Q2<Q1, user sell B and receive Q

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/Math.sol)

```solidity
File: src/mimswap/libraries/PMMPricing.sol

4:     SPDX-License-Identifier: Apache-2.0

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/PMMPricing.sol)

```solidity
File: src/mimswap/periphery/Factory.sol

18:         IFeeRateModel maintainerFeeRateModel,

27:     event LogSetMaintainerFeeRateModel(IFeeRateModel newMaintainerFeeRateModel);

33:     IFeeRateModel public maintainerFeeRateModel;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Factory.sol)

```solidity
File: src/mimswap/periphery/Router.sol

29:     error ErrDecimalsDifferenceTooLarge();

31:     uint256 public constant MAX_BASE_QUOTE_DECIMALS_DIFFERENCE = 12;

34:     IFactory public immutable factory;

66:         clone = IFactory(factory).create(baseToken, quoteToken, lpFeeRate, i, k);

88:         clone = IFactory(factory).create(useTokenAsQuote ? address(weth) : token, useTokenAsQuote ? token : address(weth), lpFeeRate, i, k);

603:             revert ErrDecimalsDifferenceTooLarge();

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Router.sol)

### <a name="NC-5"></a>[NC-5] Critical Changes Should Use Two-step Procedure
The critical procedures should be two step process.

See similar findings in previous Code4rena contests for reference: <https://code4rena.com/reports/2022-06-illuminate/#2-critical-changes-should-use-two-step-procedure>

**Recommended Mitigation Steps**

Lack of two-step procedure for critical operations leaves them error-prone. Consider adding two step procedure on the critical functions.

*Instances (1)*:
```solidity
File: src/blast/BlastOnboarding.sol

185:     function setCap(address token, uint256 cap) external onlyOwner onlySupportedTokens(token) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboarding.sol)

### <a name="NC-6"></a>[NC-6] Default Visibility for constants
Some constants are using the default visibility. For readability, consider explicitly declaring them as `internal`.

*Instances (8)*:
```solidity
File: src/blast/BlastOnboardingBoot.sol

13: address constant USDB = 0x4300000000000000000000000000000000000003;

14: address constant MIM = 0x76DA31D7C9CbEAE102aff34D3398bC450c8374c1;

15: uint256 constant FEE_RATE = 0.0005 ether; // 0.05%

16: uint256 constant K = 0.00025 ether; // 0.00025, 1.25% price fluctuation, similar to A2000 in curve

17: uint256 constant I = 0.998 ether; // 1 MIM = 0.998 USDB

18: uint256 constant USDB_TO_MIN = 1.002 ether; // 1 USDB = 1.002 MIM

19: uint256 constant MIM_TO_MIN = I;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol)

```solidity
File: src/blast/libraries/BlastYields.sol

14:     IBlast constant BLAST_YIELD_PRECOMPILE = IBlast(0x4300000000000000000000000000000000000002);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/libraries/BlastYields.sol)

### <a name="NC-7"></a>[NC-7] Functions should not be longer than 50 lines
Overly complex code can make understanding functionality more difficult, try to further modularize your code to ensure readability 

*Instances (152)*:
```solidity
File: src/blast/BlastBox.sol

52:     function claimGasYields() external onlyOperators returns (uint256) {

56:     function claimTokenYields(address token_) external onlyOperators returns (uint256 amount) {

68:     function callBlastPrecompile(bytes calldata data) external onlyOwner {

72:     function setFeeTo(address feeTo_) external onlyOwner {

81:     function setTokenEnabled(address token, bool enabled) external onlyOwner {

103:     function isOwner(address _account) internal view override returns (bool) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastBox.sol)

```solidity
File: src/blast/BlastGovernor.sol

28:     function claimNativeYields(address contractAddress) external onlyOperators returns (uint256) {

32:     function claimMaxGasYields(address contractAddress) external onlyOperators returns (uint256) {

40:     function setFeeTo(address _feeTo) external onlyOwner {

49:     function callBlastPrecompile(bytes calldata data) external onlyOwner {

53:     function execute(address to, uint256 value, bytes calldata data) external onlyOwner returns (bool success, bytes memory result) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastGovernor.sol)

```solidity
File: src/blast/BlastMagicLP.sol

39:     function version() external pure override returns (string memory) {

47:     function claimGasYields() external onlyClones onlyImplementationOperators returns (uint256) {

53:     function claimTokenYields() external onlyClones onlyImplementationOperators returns (uint256 token0Amount, uint256 token1Amount) {

64:     function updateTokenClaimables() external onlyClones onlyImplementationOperators {

72:     function callBlastPrecompile(bytes calldata data) external onlyClones onlyImplementationOwner {

80:     function setFeeTo(address feeTo_) external onlyImplementation onlyImplementationOwner {

89:     function setOperator(address operator, bool status) external onlyImplementation onlyImplementationOwner {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastMagicLP.sol)

```solidity
File: src/blast/BlastOnboarding.sol

101:     function deposit(address token, uint256 amount, bool lock_) external whenNotPaused onlyState(State.Opened) onlySupportedTokens(token) {

123:     function lock(address token, uint256 amount) external whenNotPaused onlyState(State.Opened) onlySupportedTokens(token) {

132:     function withdraw(address token, uint256 amount) external whenNotPaused onlySupportedTokens(token) {

147:     function setFeeTo(address feeTo_) external onlyOwner {

156:     function callBlastPrecompile(bytes calldata data) external onlyOwner {

160:     function claimGasYields() external onlyOwner returns (uint256) {

164:     function claimTokenYields(address[] memory tokens) external onlyOwner {

175:     function setTokenSupported(address token, bool supported) external onlyOwner {

185:     function setCap(address token, uint256 cap) external onlyOwner onlySupportedTokens(token) {

190:     function setBootstrapper(address bootstrapper_) external onlyOwner {

195:     function open() external onlyOwner onlyState(State.Idle) {

200:     function close() external onlyOwner onlyState(State.Opened) {

205:     function rescue(address token, address to, uint256 amount) external onlyOwner {

226:     function _implementation() internal view override returns (address) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboarding.sol)

```solidity
File: src/blast/BlastOnboardingBoot.sol

55:     function claim(bool lock) external returns (uint256 shares) {

78:     function claimable(address user) external view returns (uint256 shares) {

86:     function previewTotalPoolShares() external view returns (uint256 baseAdjustedInAmount, uint256 quoteAdjustedInAmount, uint256 shares) {

96:     function bootstrap(uint256 minAmountOut) external onlyOwner onlyState(State.Closed) returns (address, address, uint256) {

129:     function initialize(Router _router) external onlyOwner {

137:     function setStaking(LockingMultiRewards _staking) external onlyOwner {

146:     function setReady(bool _ready) external onlyOwner onlyState(State.Closed) {

155:     function _claimable(address user) internal view returns (uint256 shares) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol)

```solidity
File: src/blast/BlastTokenRegistry.sol

14:     function setNativeYieldTokenEnabled(address token, bool enabled) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastTokenRegistry.sol)

```solidity
File: src/blast/BlastWrappers.sol

59:     function init(bytes calldata data) public payable override {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastWrappers.sol)

```solidity
File: src/blast/libraries/BlastYields.sol

20:     function enableTokenClaimable(address token) internal {

29:     function configureDefaultClaimables(address governor_) internal {

38:     function claimMaxGasYields(address recipient) internal returns (uint256) {

42:     function claimMaxGasYields(address contractAddress, address recipient) internal returns (uint256 amount) {

51:     function claimAllNativeYields(address recipient) internal returns (uint256 amount) {

55:     function claimAllNativeYields(address contractAddress, address recipient) internal returns (uint256 amount) {

60:     function claimNativeYields(address contractAddress, uint256 amount, address recipient) internal returns (uint256) {

70:     function claimAllTokenYields(address token, address recipient) internal returns (uint256 amount) {

75:     function claimTokenYields(address token, uint256 amount, address recipient) internal returns (uint256) {

86:     function callPrecompile(bytes calldata data) internal {

87:         Address.functionCall(address(BLAST_YIELD_PRECOMPILE), data);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/libraries/BlastYields.sol)

```solidity
File: src/mimswap/MagicLP.sol

155:     function name() public view override returns (string memory) {

159:     function symbol() public pure override returns (string memory) {

163:     function decimals() public view override returns (uint8) {

193:     function getPMMState() public view returns (PMMPricing.PMMState memory state) {

204:     function getPMMStateForCall() external view returns (uint256 i, uint256 K, uint256 B, uint256 Q, uint256 B0, uint256 Q0, uint256 R) {

215:     function getMidPrice() public view returns (uint256 midPrice) {

219:     function getReserves() external view returns (uint256 baseReserve, uint256 quoteReserve) {

224:     function getUserFeeRate(address user) external view returns (uint256 lpFeeRate, uint256 mtFeeRate) {

228:     function getBaseInput() public view returns (uint256 input) {

232:     function getQuoteInput() public view returns (uint256 input) {

236:     function version() external pure virtual returns (string memory) {

244:     function sellBase(address to) external nonReentrant returns (uint256 receiveQuoteAmount) {

267:     function sellQuote(address to) external nonReentrant returns (uint256 receiveBaseAmount) {

290:     function flashLoan(uint256 baseAmount, uint256 quoteAmount, address assetTo, bytes calldata data) external nonReentrant {

360:     function buyShares(address to) external nonReentrant returns (uint256 shares, uint256 baseInput, uint256 quoteInput) {

461:     function rescue(address token, address to, uint256 amount) external onlyImplementationOwner {

504:     function ratioSync() external nonReentrant onlyImplementationOwner {

528:     function _resetTargetAndReserve() internal returns (uint256 baseBalance, uint256 quoteBalance) {

560:     function _setReserve(uint256 baseReserve, uint256 quoteReserve) internal {

581:     function _transferBaseOut(address to, uint256 amount) internal {

587:     function _transferQuoteOut(address to, uint256 amount) internal {

593:     function _mint(address to, uint256 amount) internal override {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/mimswap/auxiliary/FeeRateModel.sol

34:     function getFeeRate(address trader, uint256 lpFeeRate) external view returns (uint256 adjustedLpFeeRate, uint256 mtFeeRate) {

46:     function setMaintainer(address maintainer_) external onlyOwner {

57:     function setImplementation(address implementation_) public onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/auxiliary/FeeRateModel.sol)

```solidity
File: src/mimswap/libraries/DecimalMath.sol

23:     function mulFloor(uint256 target, uint256 d) internal pure returns (uint256) {

27:     function mulCeil(uint256 target, uint256 d) internal pure returns (uint256) {

31:     function divFloor(uint256 target, uint256 d) internal pure returns (uint256) {

35:     function divCeil(uint256 target, uint256 d) internal pure returns (uint256) {

39:     function reciprocalFloor(uint256 target) internal pure returns (uint256) {

43:     function reciprocalCeil(uint256 target) internal pure returns (uint256) {

47:     function powFloor(uint256 target, uint256 e) internal pure returns (uint256) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/DecimalMath.sol)

```solidity
File: src/mimswap/libraries/Math.sol

19:     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {

29:     function sqrt(uint256 x) internal pure returns (uint256 y) {

51:     function _GeneralIntegrate(uint256 V0, uint256 V1, uint256 V2, uint256 i, uint256 k) internal pure returns (uint256) {

79:     function _SolveQuadraticFunctionForTarget(uint256 V1, uint256 delta, uint256 i, uint256 k) internal pure returns (uint256) {

131:     function _SolveQuadraticFunctionForTrade(uint256 V0, uint256 V1, uint256 delta, uint256 i, uint256 k) internal pure returns (uint256) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/Math.sol)

```solidity
File: src/mimswap/libraries/PMMPricing.sol

39:     function sellBaseToken(PMMState memory state, uint256 payBaseAmount) internal pure returns (uint256 receiveQuoteAmount, RState newR) {

76:     function sellQuoteToken(PMMState memory state, uint256 payQuoteAmount) internal pure returns (uint256 receiveBaseAmount, RState newR) {

116:         return Math._SolveQuadraticFunctionForTrade(state.Q0, state.Q0, payBaseAmount, state.i, state.K);

129:         return Math._SolveQuadraticFunctionForTrade(state.B0, state.B0, payQuoteAmount, DecimalMath.reciprocalFloor(state.i), state.K);

157:         return Math._SolveQuadraticFunctionForTrade(state.Q0, state.Q, payBaseAmount, state.i, state.K);

185:         return Math._SolveQuadraticFunctionForTrade(state.B0, state.B, payQuoteAmount, DecimalMath.reciprocalFloor(state.i), state.K);

190:     function adjustedTarget(PMMState memory state) internal pure {

192:             state.Q0 = Math._SolveQuadraticFunctionForTarget(state.Q, state.B - state.B0, state.i, state.K);

203:     function getMidPrice(PMMState memory state) internal pure returns (uint256) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/PMMPricing.sol)

```solidity
File: src/mimswap/periphery/Factory.sol

53:     function getPoolCount(address token0, address token1) external view returns (uint256) {

57:     function getUserPoolCount(address creator) external view returns (uint256) {

81:     function create(address baseToken_, address quoteToken_, uint256 lpFeeRate_, uint256 i_, uint256 k_) external returns (address clone) {

96:     function setLpImplementation(address implementation_) external onlyOwner {

105:     function setMaintainerFeeRateModel(IFeeRateModel maintainerFeeRateModel_) external onlyOwner {

116:     function addPool(address creator, address baseToken, address quoteToken, address pool) external onlyOwner {

148:     function _addPool(address creator, address baseToken, address quoteToken, address pool) internal {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Factory.sol)

```solidity
File: src/mimswap/periphery/Router.sol

251:     function previewRemoveLiquidity(address lp, uint256 sharesIn) external view returns (uint256 baseAmountOut, uint256 quoteAmountOut) {

499:     function _addLiquidity(address lp, address to, uint256 minimumShares) internal returns (uint256 shares) {

541:     function _swap(address to, address[] calldata path, uint256 directions, uint256 minimumOut) internal returns (uint256 amountOut) {

571:     function _sellBase(address lp, address to, uint256 minimumOut) internal returns (uint256 amountOut) {

578:     function _sellQuote(address lp, address to, uint256 minimumOut) internal returns (uint256 amountOut) {

586:     function _validatePath(address[] calldata path) internal pure {

598:     function _validateDecimals(uint8 baseDecimals, uint8 quoteDecimals) internal pure {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Router.sol)

```solidity
File: src/oracles/aggregators/MagicLpAggregator.sol

29:     function decimals() external pure override returns (uint8) {

33:     function _getReserves() internal view virtual returns (uint256, uint256) {

37:     function latestAnswer() public view override returns (int256) {

48:     function latestRoundData() external view returns (uint80, int256, uint256, uint256, uint80) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/oracles/aggregators/MagicLpAggregator.sol)

```solidity
File: src/staking/LockingMultiRewards.sol

150:     function stake(uint256 amount, bool lock_) public whenNotPaused {

155:     function lock(uint256 amount) public whenNotPaused {

170:     function withdraw(uint256 amount) public virtual {

186:     function withdrawWithRewards(uint256 amount) public virtual {

199:     function rewardData(address token) external view returns (Reward memory) {

203:     function rewardsForDuration(address rewardToken) external view returns (uint256) {

207:     function rewardTokensLength() external view returns (uint256) {

211:     function balances(address user) external view returns (Balances memory) {

215:     function userRewardLock(address user) external view returns (RewardLock memory) {

219:     function userLocks(address user) external view returns (LockedBalance[] memory) {

223:     function userLocksLength(address user) external view returns (uint256) {

227:     function locked(address user) external view returns (uint256) {

231:     function unlocked(address user) external view returns (uint256) {

235:     function totalSupply() public view returns (uint256) {

239:     function balanceOf(address user) public view returns (uint256) {

253:     function nextUnlockTime() public view returns (uint256) {

261:     function nextEpoch() public view returns (uint256) {

265:     function remainingEpochTime() public view returns (uint256) {

269:     function lastTimeRewardApplicable(address rewardToken) public view returns (uint256) {

273:     function rewardPerToken(address rewardToken) public view returns (uint256) {

277:     function _rewardPerToken(address rewardToken, uint256 lastTimeRewardApplicable_, uint256 totalSupply_) public view returns (uint256) {

288:     function earned(address user, address rewardToken) public view returns (uint256) {

292:     function _earned(address user, uint256 balance_, address rewardToken, uint256 rewardPerToken_) internal view returns (uint256) {

300:     function addReward(address rewardToken) public onlyOwner {

317:     function setMinLockAmount(uint256 _minLockAmount) external onlyOwner {

324:     function recover(address tokenAddress, uint256 tokenAmount) external onlyOwner {

349:     function stakeFor(address account, uint256 amount, bool lock_) external onlyOperators {

361:     function notifyRewardAmount(address rewardToken, uint256 amount, uint minRemainingTime) public onlyOperators {

397:     function processExpiredLocks(address[] memory users, uint256[] calldata lockIndexes) external onlyOperators {

458:     function _stakeFor(address account, uint256 amount, bool lock_) internal {

479:     function _createLock(address user, uint256 amount) internal {

528:     function _updateRewardsGlobal(address token_, uint256 totalSupply_) internal returns (uint256 rewardPerToken_) {

536:     function _udpateUserRewards(address user_, uint256 balance_, address token_, uint256 rewardPerToken_) internal {

557:     function _updateRewardsForUser(address user) internal {

572:     function _updateRewardsForUsers(address[] memory users) internal {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/staking/LockingMultiRewards.sol)

### <a name="NC-8"></a>[NC-8] Change uint to uint256
Throughout the code base, some variables are declared as `uint`. To favor explicitness, consider changing all instances of `uint` to `uint256`

*Instances (2)*:
```solidity
File: src/mimswap/libraries/DecimalMath.sol

53:             uint p = powFloor(target, e / 2);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/DecimalMath.sol)

```solidity
File: src/staking/LockingMultiRewards.sol

361:     function notifyRewardAmount(address rewardToken, uint256 amount, uint minRemainingTime) public onlyOperators {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/staking/LockingMultiRewards.sol)

### <a name="NC-9"></a>[NC-9] Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor
If a function is supposed to be access-controlled, a `modifier` should be used instead of a `require/if` statement for more readability.

*Instances (5)*:
```solidity
File: src/blast/BlastMagicLP.sol

119:         if (!BlastMagicLP(address(implementation)).operators(msg.sender) && msg.sender != implementation.owner()) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastMagicLP.sol)

```solidity
File: src/blast/BlastOnboardingBoot.sol

59:         if (claimed[msg.sender]) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol)

```solidity
File: src/mimswap/MagicLP.sol

424:         if (shareAmount > balanceOf(msg.sender)) {

608:         if (msg.sender != implementation.owner()) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/mimswap/auxiliary/FeeRateModel.sol

39:         return IFeeRateImpl(implementation).getFeeRate(msg.sender, trader, lpFeeRate);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/auxiliary/FeeRateModel.sol)

### <a name="NC-10"></a>[NC-10] Consider using named mappings
Consider moving to solidity version 0.8.18 or later, and using [named mappings](https://ethereum.stackexchange.com/questions/51629/how-to-name-the-arguments-in-mapping/145555#145555) to make it easier to understand the purpose of each mapping

*Instances (3)*:
```solidity
File: src/blast/BlastBox.sol

21:     mapping(address => bool) public enabledTokens;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastBox.sol)

```solidity
File: src/blast/BlastMagicLP.sol

21:     mapping(address => bool) public operators;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastMagicLP.sol)

```solidity
File: src/blast/BlastTokenRegistry.sol

10:     mapping(address => bool) public nativeYieldTokens;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastTokenRegistry.sol)

### <a name="NC-11"></a>[NC-11] `address`s shouldn't be hard-coded
It is often better to declare `address`es as `immutable`, and assign them via constructor arguments. This allows the code to remain the same across deployments on different networks, and avoids recompilation when addresses need to change.

*Instances (5)*:
```solidity
File: src/blast/BlastOnboardingBoot.sol

13: address constant USDB = 0x4300000000000000000000000000000000000003;

14: address constant MIM = 0x76DA31D7C9CbEAE102aff34D3398bC450c8374c1;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol)

```solidity
File: src/blast/libraries/BlastPoints.sol

7:     address public constant BLAST_POINTS_OPERATOR = 0xD1025F1359422Ca16D9084908d629E0dBa60ff28;

8:     IBlastPoints public constant BLAST_POINTS = IBlastPoints(0x2536FE9ab3F511540F2f9e2eC2A805005C3Dd800);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/libraries/BlastPoints.sol)

```solidity
File: src/blast/libraries/BlastYields.sol

14:     IBlast constant BLAST_YIELD_PRECOMPILE = IBlast(0x4300000000000000000000000000000000000002);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/libraries/BlastYields.sol)

### <a name="NC-12"></a>[NC-12] Owner can renounce while system is paused
The contract owner or single user with a role is not prevented from renouncing the role/ownership while the contract is paused, which would cause any user assets stored in the protocol, to be locked indefinitely.

*Instances (4)*:
```solidity
File: src/blast/BlastOnboarding.sol

214:     function pause() external onlyOwner {

218:     function unpause() external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboarding.sol)

```solidity
File: src/staking/LockingMultiRewards.sol

337:     function pause() external onlyOwner {

341:     function unpause() external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/staking/LockingMultiRewards.sol)

### <a name="NC-13"></a>[NC-13] Take advantage of Custom Error's return value property
An important feature of Custom Error is that values such as address, tokenID, msg.value can be written inside the () sign, this kind of approach provides a serious advantage in debugging and examining the revert details of dapps such as tenderly.

*Instances (105)*:
```solidity
File: src/blast/BlastBox.sol

26:             revert ErrZeroAddress();

29:             revert ErrZeroAddress();

44:             revert ErrUnsupportedToken();

58:             revert ErrUnsupportedToken();

74:             revert ErrZeroAddress();

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastBox.sol)

```solidity
File: src/blast/BlastGovernor.sol

17:             revert ErrZeroAddress();

42:             revert ErrZeroAddress();

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastGovernor.sol)

```solidity
File: src/blast/BlastMagicLP.sol

25:             revert ErrZeroAddress();

28:             revert ErrZeroAddress();

82:             revert ErrZeroAddress();

120:             revert ErrNotAllowedImplementationOperator();

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastMagicLP.sol)

```solidity
File: src/blast/BlastOnboarding.sol

45:             revert ErrWrongState();

52:             revert ErrUnsupportedToken();

81:         revert ErrUnsupported();

86:             revert ErrZeroAddress();

90:             revert ErrZeroAddress();

115:             revert ErrCapReached();

149:             revert ErrZeroAddress();

167:                 revert ErrUnsupportedToken();

207:             revert ErrNotAllowed();

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboarding.sol)

```solidity
File: src/blast/BlastOnboardingBoot.sol

57:             revert ErrNotReady();

60:             revert ErrAlreadyClaimed();

65:             revert ErrNothingToClaim();

98:             revert ErrAlreadyBootstrapped();

109:             revert ErrInsufficientAmountOut();

139:             revert ErrCannotChangeOnceReady();

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol)

```solidity
File: src/blast/BlastTokenRegistry.sol

16:             revert ErrZeroAddress();

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastTokenRegistry.sol)

```solidity
File: src/blast/BlastWrappers.sol

22:             revert ErrZeroAddress();

36:             revert ErrZeroAddress();

49:             revert ErrZeroAddress();

52:             revert ErrInvalidGovernorAddress();

61:             revert ErrInvalidGovernorAddress();

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastWrappers.sol)

```solidity
File: src/mimswap/MagicLP.sol

100:             revert ErrInitialized();

103:             revert ErrZeroAddress();

106:             revert ErrBaseQuoteSame();

109:             revert ErrInvalidI();

112:             revert ErrInvalidK();

115:             revert ErrInvalidLPFeeRate();

303:             revert ErrFlashLoanFailed();

316:                 revert ErrFlashLoanFailed();

338:                 revert ErrFlashLoanFailed();

370:             revert ErrNoBaseInput();

378:                 revert ErrZeroQuoteAmount();

386:                 revert ErrZeroQuoteTarget();

390:                 revert ErrMintAmountNotEnough();

422:             revert ErrExpired();

425:             revert ErrNotEnough();

428:             revert ErrSellBackNotAllowed();

442:             revert ErrWithdrawNotEnough();

463:             revert ErrNotAllowed();

481:             revert ErrReserveAmountNotEnough();

484:             revert ErrInvalidI();

487:             revert ErrInvalidK();

490:             revert ErrInvalidLPFeeRate();

509:             revert ErrOverflow();

533:             revert ErrOverflow();

595:             revert ErrMintAmountNotEnough();

609:             revert ErrNotImplementationOwner();

616:             revert ErrNotClone();

623:             revert ErrNotImplementation();

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/mimswap/auxiliary/FeeRateModel.sol

24:             revert ErrZeroAddress();

48:             revert ErrZeroAddress();

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/auxiliary/FeeRateModel.sol)

```solidity
File: src/mimswap/libraries/Math.sol

53:             revert ErrIsZero();

133:             revert ErrIsZero();

193:                 revert ErrIsZero();

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/Math.sol)

```solidity
File: src/mimswap/periphery/Factory.sol

40:             revert ErrZeroAddress();

43:             revert ErrZeroAddress();

98:             revert ErrZeroAddress();

107:             revert ErrZeroAddress();

135:             revert ErrInvalidUserPoolIndex();

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Factory.sol)

```solidity
File: src/mimswap/periphery/Router.sol

40:             revert ErrZeroAddress();

49:             revert ErrExpired();

213:             revert ErrNotETHLP();

240:             revert ErrNotETHLP();

305:             revert ErrNotETHLP();

356:             revert ErrInTokenNotETH();

386:             revert ErrOutTokenNotETH();

424:             revert ErrInvalidBaseToken();

440:             revert ErrInvalidQuoteToken();

470:             revert ErrInvalidQuoteToken();

486:             revert ErrInvalidBaseToken();

591:             revert ErrPathTooLong();

594:             revert ErrEmptyPath();

600:             revert ErrZeroDecimals();

603:             revert ErrDecimalsDifferenceTooLarge();

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Router.sol)

```solidity
File: src/staking/LockingMultiRewards.sol

120:             revert ErrInvalidBoostMultiplier();

124:             revert ErrInvalidLockDuration();

128:             revert ErrInvalidRewardDuration();

132:             revert ErrInvalidDurationRatio();

157:             revert ErrZeroAmount();

172:             revert ErrZeroAmount();

302:             revert ErrInvalidTokenAddress();

306:             revert ErrRewardAlreadyExists();

310:             revert ErrMaxRewardsExceeded();

327:             revert ErrSkimmingTooMuch();

363:             revert ErrInvalidTokenAddress();

375:             revert ErrInsufficientRemainingTime();

385:             revert ErrNotEnoughReward();

399:             revert ErrLengthMismatch();

411:                 revert ErrNoLocks();

418:                 revert ErrInvalidLockIndex();

423:                 revert ErrLockNotExpired();

460:             revert ErrZeroAmount();

494:                 revert ErrMaxUserLocksExceeded();

498:                 revert ErrLockAmountTooSmall();

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/staking/LockingMultiRewards.sol)

### <a name="NC-14"></a>[NC-14] Use scientific notation (e.g. `1e18`) rather than exponentiation (e.g. `10**18`)
While this won't save gas in the recent solidity versions, this is shorter and more readable (this is especially true in calculations).

*Instances (5)*:
```solidity
File: src/mimswap/MagicLP.sol

63:     uint256 public constant MAX_I = 10 ** 36;

64:     uint256 public constant MAX_K = 10 ** 18;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/mimswap/libraries/DecimalMath.sol

20:     uint256 internal constant ONE = 10 ** 18;

21:     uint256 internal constant ONE2 = 10 ** 36;

49:             return 10 ** 18;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/DecimalMath.sol)

### <a name="NC-15"></a>[NC-15] Avoid the use of sensitive terms
Use [alternative variants](https://www.zdnet.com/article/mysql-drops-master-slave-and-blacklist-whitelist-terminology/), e.g. allowlist/denylist instead of whitelist/blacklist

*Instances (4)*:
```solidity
File: src/blast/BlastWrappers.sol

56:         _setupBlacklist();

64:         _setupBlacklist();

70:     function _setupBlacklist() private {

71:         blacklistedCallees[address(BlastYields.BLAST_YIELD_PRECOMPILE)] = true;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastWrappers.sol)

### <a name="NC-16"></a>[NC-16] Use Underscores for Number Literals (add an underscore every 3 digits)

*Instances (13)*:
```solidity
File: src/mimswap/MagicLP.sol

3:     Copyright 2020 DODO ZOO.

389:             if (shares <= 2001) {

393:             _mint(address(0), 1001);

394:             shares -= 1001;

594:         if (amount <= 1000) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/mimswap/auxiliary/FeeRateModel.sol

3:     Copyright 2020 DODO ZOO.

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/auxiliary/FeeRateModel.sol)

```solidity
File: src/mimswap/libraries/DecimalMath.sol

3:     Copyright 2020 DODO ZOO.

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/DecimalMath.sol)

```solidity
File: src/mimswap/libraries/Math.sol

3:     Copyright 2020 DODO ZOO.

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/Math.sol)

```solidity
File: src/mimswap/libraries/PMMPricing.sol

3:     Copyright 2020 DODO ZOO.

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/PMMPricing.sol)

```solidity
File: src/mimswap/periphery/Router.sol

105:         if (shares <= 2001) {

109:         shares -= 1001;

142:             if (shares <= 2001) {

146:             shares -= 1001;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Router.sol)

### <a name="NC-17"></a>[NC-17] Constants should be defined rather than using magic numbers

*Instances (1)*:
```solidity
File: src/mimswap/periphery/Router.sol

83:             _validateDecimals(18, IERC20Metadata(token).decimals());

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Router.sol)

### <a name="NC-18"></a>[NC-18] Variables need not be initialized to zero
The default value for variables is zero, so initializing them to zero is superfluous.

*Instances (2)*:
```solidity
File: src/blast/BlastOnboarding.sol

165:         for (uint256 i = 0; i < tokens.length; i++) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboarding.sol)

```solidity
File: src/mimswap/periphery/Router.sol

544:         for (uint256 i = 0; i < iterations; ) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Router.sol)


## Low Issues


| |Issue|Instances|
|-|:-|:-:|
| [L-1](#L-1) | `approve()`/`safeApprove()` may revert if the current approval is not zero | 3 |
| [L-2](#L-2) | Use of `tx.origin` is unsafe in almost every context | 5 |
| [L-3](#L-3) | Use of `tx.origin` is unsafe in almost every context | 5 |
| [L-4](#L-4) | `decimals()` is not a part of the ERC-20 standard | 8 |
| [L-5](#L-5) | Do not use deprecated library functions | 3 |
| [L-6](#L-6) | `safeApprove()` is deprecated | 3 |
| [L-7](#L-7) | Division by zero not prevented | 27 |
| [L-8](#L-8) | External call recipient may consume all transaction gas | 5 |
| [L-9](#L-9) | Initializers could be front-run | 5 |
| [L-10](#L-10) | Signature use at deadlines should be allowed | 3 |
| [L-11](#L-11) | Owner can renounce while system is paused | 4 |
| [L-12](#L-12) | Possible rounding issue | 9 |
| [L-13](#L-13) | Loss of precision | 20 |
| [L-14](#L-14) | Use `Ownable2Step.transferOwnership` instead of `Ownable.transferOwnership` | 1 |
| [L-15](#L-15) | `symbol()` is not a part of the ERC-20 standard | 1 |
| [L-16](#L-16) | Unspecific compiler version pragma | 20 |
| [L-17](#L-17) | Upgradeable contract not initialized | 12 |
### <a name="L-1"></a>[L-1] `approve()`/`safeApprove()` may revert if the current approval is not zero
- Some tokens (like the *very popular* USDT) do not work when changing the allowance from an existing non-zero allowance value (it will revert if the current approval is not zero to protect against front-running changes of approvals). These tokens must first be approved for zero and then the actual allowance can be approved.
- Furthermore, OZ's implementation of safeApprove would throw an error if an approve is attempted from a non-zero value (`"SafeERC20: approve from non-zero to non-zero allowance"`)

Set the allowance to zero immediately before each of the existing allowance calls

*Instances (3)*:
```solidity
File: src/blast/BlastOnboardingBoot.sol

103:         MIM.safeApprove(address(router), type(uint256).max);

104:         USDB.safeApprove(address(router), type(uint256).max);

122:         pool.safeApprove(address(staking), totalPoolShares);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol)

### <a name="L-2"></a>[L-2] Use of `tx.origin` is unsafe in almost every context
According to [Vitalik Buterin](https://ethereum.stackexchange.com/questions/196/how-do-i-make-my-dapp-serenity-proof), contracts should _not_ `assume that tx.origin will continue to be usable or meaningful`. An example of this is [EIP-3074](https://eips.ethereum.org/EIPS/eip-3074#allowing-txorigin-as-signer-1) which explicitly mentions the intention to change its semantics when it's used with new op codes. There have also been calls to [remove](https://github.com/ethereum/solidity/issues/683) `tx.origin`, and there are [security issues](solidity.readthedocs.io/en/v0.4.24/security-considerations.html#tx-origin) associated with using it for authorization. For these reasons, it's best to completely avoid the feature.

*Instances (5)*:
```solidity
File: src/mimswap/MagicLP.sol

250:         (receiveQuoteAmount, mtFee, newRState, newBaseTarget) = querySellBase(tx.origin, baseInput);

273:         (receiveBaseAmount, mtFee, newRState, newQuoteTarget) = querySellQuote(tx.origin, quoteInput);

311:                 tx.origin,

333:                 tx.origin,

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/mimswap/periphery/Factory.sol

82:         address creator = tx.origin;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Factory.sol)

### <a name="L-3"></a>[L-3] Use of `tx.origin` is unsafe in almost every context
According to [Vitalik Buterin](https://ethereum.stackexchange.com/questions/196/how-do-i-make-my-dapp-serenity-proof), contracts should _not_ `assume that tx.origin will continue to be usable or meaningful`. An example of this is [EIP-3074](https://eips.ethereum.org/EIPS/eip-3074#allowing-txorigin-as-signer-1) which explicitly mentions the intention to change its semantics when it's used with new op codes. There have also been calls to [remove](https://github.com/ethereum/solidity/issues/683) `tx.origin`, and there are [security issues](solidity.readthedocs.io/en/v0.4.24/security-considerations.html#tx-origin) associated with using it for authorization. For these reasons, it's best to completely avoid the feature.

*Instances (5)*:
```solidity
File: src/mimswap/MagicLP.sol

250:         (receiveQuoteAmount, mtFee, newRState, newBaseTarget) = querySellBase(tx.origin, baseInput);

273:         (receiveBaseAmount, mtFee, newRState, newQuoteTarget) = querySellQuote(tx.origin, quoteInput);

311:                 tx.origin,

333:                 tx.origin,

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/mimswap/periphery/Factory.sol

82:         address creator = tx.origin;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Factory.sol)

### <a name="L-4"></a>[L-4] `decimals()` is not a part of the ERC-20 standard
The `decimals()` function is not a part of the [ERC-20 standard](https://eips.ethereum.org/EIPS/eip-20), and was added later as an [optional extension](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol). As such, some valid ERC20 tokens do not support this interface, so it is unsafe to blindly cast all tokens to this interface, and then call this function.

*Instances (8)*:
```solidity
File: src/mimswap/MagicLP.sol

164:         return IERC20Metadata(_BASE_TOKEN_).decimals();

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/mimswap/periphery/Router.sol

64:         _validateDecimals(IERC20Metadata(baseToken).decimals(), IERC20Metadata(quoteToken).decimals());

83:             _validateDecimals(18, IERC20Metadata(token).decimals());

85:             _validateDecimals(IERC20Metadata(token).decimals(), 18);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Router.sol)

```solidity
File: src/oracles/aggregators/MagicLpAggregator.sol

25:         baseDecimals = IERC20Metadata(pair_._BASE_TOKEN_()).decimals();

26:         quoteDecimals = IERC20Metadata(pair_._QUOTE_TOKEN_()).decimals();

38:         uint256 baseAnswerNomalized = uint256(baseOracle.latestAnswer()) * (10 ** (WAD - baseOracle.decimals()));

39:         uint256 quoteAnswerNormalized = uint256(quoteOracle.latestAnswer()) * (10 ** (WAD - quoteOracle.decimals()));

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/oracles/aggregators/MagicLpAggregator.sol)

### <a name="L-5"></a>[L-5] Do not use deprecated library functions

*Instances (3)*:
```solidity
File: src/blast/BlastOnboardingBoot.sol

103:         MIM.safeApprove(address(router), type(uint256).max);

104:         USDB.safeApprove(address(router), type(uint256).max);

122:         pool.safeApprove(address(staking), totalPoolShares);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol)

### <a name="L-6"></a>[L-6] `safeApprove()` is deprecated
[Deprecated](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/bfff03c0d2a59bcd8e2ead1da9aed9edf0080d05/contracts/token/ERC20/utils/SafeERC20.sol#L38-L45) in favor of `safeIncreaseAllowance()` and `safeDecreaseAllowance()`. If only setting the initial allowance to the value that means infinite, `safeIncreaseAllowance()` can be used instead. The function may currently work, but if a bug is found in this version of OpenZeppelin, and the version that you're forced to upgrade to no longer has this function, you'll encounter unnecessary delays in porting and testing replacement contracts.

*Instances (3)*:
```solidity
File: src/blast/BlastOnboardingBoot.sol

103:         MIM.safeApprove(address(router), type(uint256).max);

104:         USDB.safeApprove(address(router), type(uint256).max);

122:         pool.safeApprove(address(staking), totalPoolShares);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol)

### <a name="L-7"></a>[L-7] Division by zero not prevented
The divisions below take an input parameter which does not have any zero-value checks, which may lead to the functions reverting when zero is passed.

*Instances (27)*:
```solidity
File: src/blast/BlastOnboardingBoot.sol

163:         return (userLocked * totalPoolShares) / totalLocked;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol)

```solidity
File: src/mimswap/MagicLP.sol

435:         baseAmount = (baseBalance * shareAmount) / totalShares;

513:             _BASE_TARGET_ = uint112((uint256(_BASE_TARGET_) * baseBalance) / uint256(_BASE_RESERVE_));

517:             _QUOTE_TARGET_ = uint112((uint256(_QUOTE_TARGET_) * quoteBalance) / uint256(_QUOTE_RESERVE_));

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/mimswap/libraries/DecimalMath.sol

32:         return (target * ONE) / d;

40:         return ONE2 / target;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/DecimalMath.sol)

```solidity
File: src/mimswap/libraries/Math.sol

20:         uint256 quotient = a / b;

34:             z = (x / z + z) / 2;

59:             return fairAmount / DecimalMath.ONE;

62:         uint256 V0V0V1V2 = DecimalMath.divFloor((V0 * V0) / V1, V2);

64:         return (((DecimalMath.ONE - k) + penalty) * fairAmount) / DecimalMath.ONE2;

96:         } else if ((ki * delta) / ki == delta) {

99:             _sqrt = sqrt(((ki / V1) * delta) + DecimalMath.ONE2);

155:             } else if ((idelta * V1) / idelta == V1) {

156:                 temp = (idelta * V1) / (V0 * V0);

158:                 temp = (((delta * V1) / V0) * i) / V0;

160:             return (V1 * temp) / (temp + DecimalMath.ONE);

170:         uint256 part2 = (((k * V0) / V1) * V0) + (i * delta); // kQ0^2/Q1-i*deltaB

181:         bAbs = bAbs / DecimalMath.ONE;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/Math.sol)

```solidity
File: src/mimswap/libraries/PMMPricing.sol

205:             uint256 R = DecimalMath.divFloor((state.Q0 * state.Q0) / state.Q, state.Q);

209:             uint256 R = DecimalMath.divFloor((state.B0 * state.B0) / state.B, state.B);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/PMMPricing.sol)

```solidity
File: src/mimswap/periphery/Router.sol

257:         baseAmountOut = (baseBalance * sharesIn) / totalShares;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Router.sol)

```solidity
File: src/oracles/aggregators/MagicLpAggregator.sol

45:         return int256(minAnswer * (baseReserve + quoteReserve) / pair.totalSupply());

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/oracles/aggregators/MagicLpAggregator.sol)

```solidity
File: src/staking/LockingMultiRewards.sol

144:         maxLocks = _lockDuration / _rewardsDuration;

258:         return (block.timestamp / rewardsDuration) * rewardsDuration;

283:         uint256 pendingRewardsPerToken = (timeElapsed * _rewardData[rewardToken].rewardRate * 1e18) / totalSupply_;

388:         reward.rewardRate = amount / _remainingRewardTime;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/staking/LockingMultiRewards.sol)

### <a name="L-8"></a>[L-8] External call recipient may consume all transaction gas
There is no limit specified on the amount of gas used, so the recipient can use up all of the transaction's gas, causing it to revert. Use `addr.call{gas: <amount>}("")` or [this](https://github.com/nomad-xyz/ExcessivelySafeCall) library instead.

*Instances (5)*:
```solidity
File: src/blast/BlastBox.sol

69:         BlastYields.callPrecompile(data);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastBox.sol)

```solidity
File: src/blast/BlastGovernor.sol

50:         BlastYields.callPrecompile(data);

54:         (success, result) = to.call{value: value}(data);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastGovernor.sol)

```solidity
File: src/blast/BlastMagicLP.sol

73:         BlastYields.callPrecompile(data);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastMagicLP.sol)

```solidity
File: src/blast/BlastOnboarding.sol

157:         BlastYields.callPrecompile(data);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboarding.sol)

### <a name="L-9"></a>[L-9] Initializers could be front-run
Initializers could be front-run, allowing an attacker to either set their own values, take ownership of the contract, and in the best case forcing a re-deployment

*Instances (5)*:
```solidity
File: src/blast/BlastOnboardingBoot.sol

129:     function initialize(Router _router) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol)

```solidity
File: src/blast/BlastWrappers.sol

59:     function init(bytes calldata data) public payable override {

66:         super.init(data);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastWrappers.sol)

```solidity
File: src/mimswap/MagicLP.sol

91:     function init(

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/mimswap/periphery/Factory.sol

86:         IMagicLP(clone).init(address(baseToken_), address(quoteToken_), lpFeeRate_, address(maintainerFeeRateModel), i_, k_);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Factory.sol)

### <a name="L-10"></a>[L-10] Signature use at deadlines should be allowed
According to [EIP-2612](https://github.com/ethereum/EIPs/blob/71dc97318013bf2ac572ab63fab530ac9ef419ca/EIPS/eip-2612.md?plain=1#L58), signatures used on exactly the deadline timestamp are supposed to be allowed. While the signature may or may not be used for the exact EIP-2612 use case (transfer approvals), for consistency's sake, all deadlines should follow this semantic. If the timestamp is an expiration rather than a deadline, consider whether it makes more sense to include the expiration timestamp as a valid timestamp, as is done for deadlines.

*Instances (3)*:
```solidity
File: src/mimswap/MagicLP.sol

421:         if (deadline < block.timestamp) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/staking/LockingMultiRewards.sol

422:             if (locks[index].unlockTime > block.timestamp) {

602:         bool expired = _rewardLock.unlockTime <= block.timestamp;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/staking/LockingMultiRewards.sol)

### <a name="L-11"></a>[L-11] Owner can renounce while system is paused
The contract owner or single user with a role is not prevented from renouncing the role/ownership while the contract is paused, which would cause any user assets stored in the protocol, to be locked indefinitely.

*Instances (4)*:
```solidity
File: src/blast/BlastOnboarding.sol

214:     function pause() external onlyOwner {

218:     function unpause() external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboarding.sol)

```solidity
File: src/staking/LockingMultiRewards.sol

337:     function pause() external onlyOwner {

341:     function unpause() external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/staking/LockingMultiRewards.sol)

### <a name="L-12"></a>[L-12] Possible rounding issue
Division by large numbers may result in the result being zero, due to solidity not supporting fractions. Consider requiring a minimum amount for the numerator to ensure that it is always larger than the denominator. Also, there is indication of multiplication and division without the use of parenthesis which could result in issues.

*Instances (9)*:
```solidity
File: src/blast/BlastOnboardingBoot.sol

163:         return (userLocked * totalPoolShares) / totalLocked;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol)

```solidity
File: src/mimswap/MagicLP.sol

435:         baseAmount = (baseBalance * shareAmount) / totalShares;

436:         quoteAmount = (quoteBalance * shareAmount) / totalShares;

513:             _BASE_TARGET_ = uint112((uint256(_BASE_TARGET_) * baseBalance) / uint256(_BASE_RESERVE_));

517:             _QUOTE_TARGET_ = uint112((uint256(_QUOTE_TARGET_) * quoteBalance) / uint256(_QUOTE_RESERVE_));

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/mimswap/periphery/Router.sol

257:         baseAmountOut = (baseBalance * sharesIn) / totalShares;

258:         quoteAmountOut = (quoteBalance * sharesIn) / totalShares;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Router.sol)

```solidity
File: src/oracles/aggregators/MagicLpAggregator.sol

45:         return int256(minAnswer * (baseReserve + quoteReserve) / pair.totalSupply());

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/oracles/aggregators/MagicLpAggregator.sol)

```solidity
File: src/staking/LockingMultiRewards.sol

283:         uint256 pendingRewardsPerToken = (timeElapsed * _rewardData[rewardToken].rewardRate * 1e18) / totalSupply_;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/staking/LockingMultiRewards.sol)

### <a name="L-13"></a>[L-13] Loss of precision
Division by large numbers may result in the result being zero, due to solidity not supporting fractions. Consider requiring a minimum amount for the numerator to ensure that it is always larger than the denominator

*Instances (20)*:
```solidity
File: src/blast/BlastOnboardingBoot.sol

163:         return (userLocked * totalPoolShares) / totalLocked;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol)

```solidity
File: src/mimswap/MagicLP.sol

435:         baseAmount = (baseBalance * shareAmount) / totalShares;

436:         quoteAmount = (quoteBalance * shareAmount) / totalShares;

513:             _BASE_TARGET_ = uint112((uint256(_BASE_TARGET_) * baseBalance) / uint256(_BASE_RESERVE_));

517:             _QUOTE_TARGET_ = uint112((uint256(_QUOTE_TARGET_) * quoteBalance) / uint256(_QUOTE_RESERVE_));

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/mimswap/libraries/DecimalMath.sol

24:         return (target * d) / ONE;

54:             p = (p * p) / ONE;

56:                 p = (p * target) / ONE;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/DecimalMath.sol)

```solidity
File: src/mimswap/libraries/Math.sol

59:             return fairAmount / DecimalMath.ONE;

64:         return (((DecimalMath.ONE - k) + penalty) * fairAmount) / DecimalMath.ONE2;

97:             _sqrt = sqrt(((ki * delta) / V1) + DecimalMath.ONE2);

99:             _sqrt = sqrt(((ki / V1) * delta) + DecimalMath.ONE2);

160:             return (V1 * temp) / (temp + DecimalMath.ONE);

181:         bAbs = bAbs / DecimalMath.ONE;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/Math.sol)

```solidity
File: src/mimswap/periphery/Router.sol

257:         baseAmountOut = (baseBalance * sharesIn) / totalShares;

258:         quoteAmountOut = (quoteBalance * sharesIn) / totalShares;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Router.sol)

```solidity
File: src/oracles/aggregators/MagicLpAggregator.sol

45:         return int256(minAnswer * (baseReserve + quoteReserve) / pair.totalSupply());

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/oracles/aggregators/MagicLpAggregator.sol)

```solidity
File: src/staking/LockingMultiRewards.sol

236:         return unlockedSupply + ((lockedSupply * lockingBoostMultiplerInBips) / BIPS);

241:         return bal.unlocked + ((bal.locked * lockingBoostMultiplerInBips) / BIPS);

283:         uint256 pendingRewardsPerToken = (timeElapsed * _rewardData[rewardToken].rewardRate * 1e18) / totalSupply_;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/staking/LockingMultiRewards.sol)

### <a name="L-14"></a>[L-14] Use `Ownable2Step.transferOwnership` instead of `Ownable.transferOwnership`
Use [Ownable2Step.transferOwnership](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable2Step.sol) which is safer. Use it as it is more secure due to 2-stage ownership transfer.

**Recommended Mitigation Steps**

Use <a href="https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable2Step.sol">Ownable2Step.sol</a>
  
  ```solidity
      function acceptOwnership() external {
          address sender = _msgSender();
          require(pendingOwner() == sender, "Ownable2Step: caller is not the new owner");
          _transferOwnership(sender);
      }
```

*Instances (1)*:
```solidity
File: src/blast/BlastOnboardingBoot.sol

119:         staking.transferOwnership(owner);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol)

### <a name="L-15"></a>[L-15] `symbol()` is not a part of the ERC-20 standard
The `symbol()` function is not a part of the [ERC-20 standard](https://eips.ethereum.org/EIPS/eip-20), and was added later as an [optional extension](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol). As such, some valid ERC20 tokens do not support this interface, so it is unsafe to blindly cast all tokens to this interface, and then call this function.

*Instances (1)*:
```solidity
File: src/mimswap/MagicLP.sol

156:         return string(abi.encodePacked("MagicLP ", IERC20Metadata(_BASE_TOKEN_).symbol(), "/", IERC20Metadata(_QUOTE_TOKEN_).symbol()));

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

### <a name="L-16"></a>[L-16] Unspecific compiler version pragma

*Instances (20)*:
```solidity
File: src/blast/BlastBox.sol

3: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastBox.sol)

```solidity
File: src/blast/BlastDapp.sol

2: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastDapp.sol)

```solidity
File: src/blast/BlastGovernor.sol

2: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastGovernor.sol)

```solidity
File: src/blast/BlastMagicLP.sol

3: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastMagicLP.sol)

```solidity
File: src/blast/BlastOnboarding.sol

2: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboarding.sol)

```solidity
File: src/blast/BlastOnboardingBoot.sol

2: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol)

```solidity
File: src/blast/BlastTokenRegistry.sol

2: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastTokenRegistry.sol)

```solidity
File: src/blast/BlastWrappers.sol

2: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastWrappers.sol)

```solidity
File: src/blast/libraries/BlastPoints.sol

2: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/libraries/BlastPoints.sol)

```solidity
File: src/blast/libraries/BlastYields.sol

2: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/libraries/BlastYields.sol)

```solidity
File: src/mimswap/MagicLP.sol

8: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/mimswap/auxiliary/FeeRateModel.sol

8: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/auxiliary/FeeRateModel.sol)

```solidity
File: src/mimswap/auxiliary/FeeRateModelImpl.sol

2: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/auxiliary/FeeRateModelImpl.sol)

```solidity
File: src/mimswap/libraries/DecimalMath.sol

7: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/DecimalMath.sol)

```solidity
File: src/mimswap/libraries/Math.sol

8: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/Math.sol)

```solidity
File: src/mimswap/libraries/PMMPricing.sol

8: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/libraries/PMMPricing.sol)

```solidity
File: src/mimswap/periphery/Factory.sol

2: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Factory.sol)

```solidity
File: src/mimswap/periphery/Router.sol

2: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Router.sol)

```solidity
File: src/oracles/aggregators/MagicLpAggregator.sol

2: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/oracles/aggregators/MagicLpAggregator.sol)

```solidity
File: src/staking/LockingMultiRewards.sol

2: pragma solidity >=0.8.0;

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/staking/LockingMultiRewards.sol)

### <a name="L-17"></a>[L-17] Upgradeable contract not initialized
Upgradeable contracts are initialized via an initializer function rather than by a constructor. Leaving such a contract uninitialized may lead to it being taken over by a malicious user

*Instances (12)*:
```solidity
File: src/blast/BlastMagicLP.sol

98:     function _afterInitialized() internal override {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastMagicLP.sol)

```solidity
File: src/blast/BlastOnboardingBoot.sol

39:     event LogInitialized(Router indexed router);

129:     function initialize(Router _router) external onlyOwner {

132:         emit LogInitialized(_router);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol)

```solidity
File: src/mimswap/MagicLP.sol

38:     error ErrInitialized();

68:     bool internal _INITIALIZED_;

88:         _INITIALIZED_ = true;

99:         if (_INITIALIZED_) {

100:             revert ErrInitialized();

118:         _INITIALIZED_ = true;

127:         _afterInitialized();

601:     function _afterInitialized() internal virtual {}

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)


## Medium Issues


| |Issue|Instances|
|-|:-|:-:|
| [M-1](#M-1) | Centralization Risk for trusted owners | 44 |
| [M-2](#M-2) | Use of deprecated chainlink function: `latestAnswer()` | 2 |
| [M-3](#M-3) | Solady's SafeTransferLib does not check for token contract's existence | 40 |
### <a name="M-1"></a>[M-1] Centralization Risk for trusted owners

#### Impact:
Contracts have owners with privileged rights to perform admin tasks and need to be trusted to not perform malicious updates or drain funds.

*Instances (44)*:
```solidity
File: src/blast/BlastBox.sol

68:     function callBlastPrecompile(bytes calldata data) external onlyOwner {

72:     function setFeeTo(address feeTo_) external onlyOwner {

81:     function setTokenEnabled(address token, bool enabled) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastBox.sol)

```solidity
File: src/blast/BlastGovernor.sol

40:     function setFeeTo(address _feeTo) external onlyOwner {

49:     function callBlastPrecompile(bytes calldata data) external onlyOwner {

53:     function execute(address to, uint256 value, bytes calldata data) external onlyOwner returns (bool success, bytes memory result) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastGovernor.sol)

```solidity
File: src/blast/BlastOnboarding.sol

12: contract BlastOnboardingData is Owned, Pausable {

58:     constructor() Owned(msg.sender) {

147:     function setFeeTo(address feeTo_) external onlyOwner {

156:     function callBlastPrecompile(bytes calldata data) external onlyOwner {

160:     function claimGasYields() external onlyOwner returns (uint256) {

164:     function claimTokenYields(address[] memory tokens) external onlyOwner {

175:     function setTokenSupported(address token, bool supported) external onlyOwner {

185:     function setCap(address token, uint256 cap) external onlyOwner onlySupportedTokens(token) {

190:     function setBootstrapper(address bootstrapper_) external onlyOwner {

195:     function open() external onlyOwner onlyState(State.Idle) {

200:     function close() external onlyOwner onlyState(State.Opened) {

205:     function rescue(address token, address to, uint256 amount) external onlyOwner {

214:     function pause() external onlyOwner {

218:     function unpause() external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboarding.sol)

```solidity
File: src/blast/BlastOnboardingBoot.sol

96:     function bootstrap(uint256 minAmountOut) external onlyOwner onlyState(State.Closed) returns (address, address, uint256) {

129:     function initialize(Router _router) external onlyOwner {

137:     function setStaking(LockingMultiRewards _staking) external onlyOwner {

146:     function setReady(bool _ready) external onlyOwner onlyState(State.Closed) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol)

```solidity
File: src/blast/BlastTokenRegistry.sol

6: contract BlastTokenRegistry is Owned {

12:     constructor(address _owner) Owned(_owner) {}

14:     function setNativeYieldTokenEnabled(address token, bool enabled) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastTokenRegistry.sol)

```solidity
File: src/mimswap/MagicLP.sol

25: contract MagicLP is ERC20, ReentrancyGuard, Owned {

84:     constructor(address owner_) Owned(owner_) {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/mimswap/auxiliary/FeeRateModel.sol

13: contract FeeRateModel is Owned {

22:     constructor(address maintainer_, address owner_) Owned(owner_) {

46:     function setMaintainer(address maintainer_) external onlyOwner {

57:     function setImplementation(address implementation_) public onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/auxiliary/FeeRateModel.sol)

```solidity
File: src/mimswap/periphery/Factory.sol

11: contract Factory is Owned {

38:     constructor(address implementation_, IFeeRateModel maintainerFeeRateModel_, address owner_) Owned(owner_) {

96:     function setLpImplementation(address implementation_) external onlyOwner {

105:     function setMaintainerFeeRateModel(IFeeRateModel maintainerFeeRateModel_) external onlyOwner {

116:     function addPool(address creator, address baseToken, address quoteToken, address pool) external onlyOwner {

126:     ) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Factory.sol)

```solidity
File: src/staking/LockingMultiRewards.sol

300:     function addReward(address rewardToken) public onlyOwner {

317:     function setMinLockAmount(uint256 _minLockAmount) external onlyOwner {

324:     function recover(address tokenAddress, uint256 tokenAmount) external onlyOwner {

337:     function pause() external onlyOwner {

341:     function unpause() external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/staking/LockingMultiRewards.sol)

### <a name="M-2"></a>[M-2] Use of deprecated chainlink function: `latestAnswer()`
According to Chainlink’s documentation [(API Reference)](https://docs.chain.link/data-feeds/api-reference#latestanswer), the latestAnswer function is deprecated. This function does not throw an error if no answer has been reached, but instead returns 0, possibly causing an incorrect price to be fed to the different price feeds or even a Denial of Service.

*Instances (2)*:
```solidity
File: src/oracles/aggregators/MagicLpAggregator.sol

38:         uint256 baseAnswerNomalized = uint256(baseOracle.latestAnswer()) * (10 ** (WAD - baseOracle.decimals()));

39:         uint256 quoteAnswerNormalized = uint256(quoteOracle.latestAnswer()) * (10 ** (WAD - quoteOracle.decimals()));

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/oracles/aggregators/MagicLpAggregator.sol)

### <a name="M-3"></a>[M-3] Solady's SafeTransferLib does not check for token contract's existence
There is a subtle difference between the implementation of solady’s SafeTransferLib and OZ’s SafeERC20: OZ’s SafeERC20 checks if the token is a contract or not, solady’s SafeTransferLib does not.
https://github.com/Vectorized/solady/blob/main/src/utils/SafeTransferLib.sol#L10 
`@dev Note that none of the functions in this library check that a token has code at all! That responsibility is delegated to the caller` 


*Instances (40)*:
```solidity
File: src/blast/BlastOnboarding.sol

102:         token.safeTransferFrom(msg.sender, address(this), amount);

138:         token.safeTransfer(msg.sender, amount);

210:         token.safeTransfer(to, amount);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboarding.sol)

```solidity
File: src/blast/BlastOnboardingBoot.sol

103:         MIM.safeApprove(address(router), type(uint256).max);

104:         USDB.safeApprove(address(router), type(uint256).max);

122:         pool.safeApprove(address(staking), totalPoolShares);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/blast/BlastOnboardingBoot.sol)

```solidity
File: src/mimswap/MagicLP.sol

466:         token.safeTransfer(to, amount);

583:             _BASE_TOKEN_.safeTransfer(to, amount);

589:             _QUOTE_TOKEN_.safeTransfer(to, amount);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/MagicLP.sol)

```solidity
File: src/mimswap/periphery/Router.sol

68:         baseToken.safeTransferFrom(msg.sender, clone, baseInAmount);

69:         quoteToken.safeTransferFrom(msg.sender, clone, quoteInAmount);

91:         token.safeTransferFrom(msg.sender, clone, tokenInAmount);

92:         address(weth).safeTransferFrom(address(this), clone, msg.value);

172:         IMagicLP(lp)._BASE_TOKEN_().safeTransferFrom(msg.sender, lp, baseAdjustedInAmount);

173:         IMagicLP(lp)._QUOTE_TOKEN_().safeTransferFrom(msg.sender, lp, quoteAdjustedInAmount);

186:         IMagicLP(lp)._BASE_TOKEN_().safeTransferFrom(msg.sender, lp, baseInAmount);

187:         IMagicLP(lp)._QUOTE_TOKEN_().safeTransferFrom(msg.sender, lp, quoteInAmount);

217:         address(weth).safeTransfer(lp, wethAdjustedAmount);

224:         token.safeTransferFrom(msg.sender, lp, tokenAdjustedAmount);

244:         address(weth).safeTransfer(lp, msg.value);

246:         token.safeTransferFrom(msg.sender, lp, tokenInAmount);

269:         lp.safeTransferFrom(msg.sender, address(this), sharesIn);

282:         lp.safeTransferFrom(msg.sender, address(this), sharesIn);

311:         token.safeTransfer(to, tokenAmountOut);

328:             IMagicLP(firstLp)._BASE_TOKEN_().safeTransferFrom(msg.sender, address(firstLp), amountIn);

330:             IMagicLP(firstLp)._QUOTE_TOKEN_().safeTransferFrom(msg.sender, address(firstLp), amountIn);

360:         inToken.safeTransfer(address(firstLp), msg.value);

393:             IMagicLP(firstLp)._BASE_TOKEN_().safeTransferFrom(msg.sender, firstLp, amountIn);

395:             IMagicLP(firstLp)._QUOTE_TOKEN_().safeTransferFrom(msg.sender, firstLp, amountIn);

411:         IMagicLP(lp)._BASE_TOKEN_().safeTransferFrom(msg.sender, lp, amountIn);

428:         baseToken.safeTransfer(lp, msg.value);

443:         IMagicLP(lp)._BASE_TOKEN_().safeTransferFrom(msg.sender, lp, amountIn);

456:         IMagicLP(lp)._QUOTE_TOKEN_().safeTransferFrom(msg.sender, lp, amountIn);

474:         quoteToken.safeTransfer(lp, msg.value);

489:         IMagicLP(lp)._QUOTE_TOKEN_().safeTransferFrom(msg.sender, lp, amountIn);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/mimswap/periphery/Router.sol)

```solidity
File: src/staking/LockingMultiRewards.sol

180:         stakingToken.safeTransfer(msg.sender, amount);

330:         tokenAddress.safeTransfer(owner, tokenAmount);

367:         rewardToken.safeTransferFrom(msg.sender, address(this), amount);

464:         stakingToken.safeTransferFrom(msg.sender, address(this), amount);

637:                         rewardToken.safeTransfer(user, amount);

```
[Link to code](https://github.com/code-423n4/2024-03-abracadabra-money/blob/main/src/staking/LockingMultiRewards.sol)
