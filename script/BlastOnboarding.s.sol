// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import "utils/BaseScript.sol";
import {BlastOnboarding} from "/blast/BlastOnboarding.sol";
import {IERC20} from "BoringSolidity/interfaces/IERC20.sol";
import {IOracle} from "interfaces/IOracle.sol";
import {ICauldronV4} from "interfaces/ICauldronV4.sol";
import {IBentoBoxV1} from "interfaces/IBentoBoxV1.sol";
import {IBlast} from "interfaces/IBlast.sol";
import {BlastYields} from "/blast/libraries/BlastYields.sol";

contract BlastOnboardingScript is BaseScript {
    function deploy() public returns (BlastOnboarding onboarding) {
        address owner = toolkit.getAddress(block.chainid, "safe.ops");
        address feeTo = toolkit.getAddress(block.chainid, "safe.ops");
        address blastGovernor = toolkit.getAddress(block.chainid, "blastGovernor");
        address blastTokenRegistry = toolkit.getAddress(block.chainid, "blastTokenRegistry");

        vm.startBroadcast();

        onboarding = BlastOnboarding(
            payable(deploy("Onboarding", "BlastOnboarding.sol:BlastOnboarding", abi.encode(blastTokenRegistry, feeTo, tx.origin)))
        );

        if (!testing()) {
            address usdb = toolkit.getAddress(block.chainid, "usdb");
            address mim = toolkit.getAddress(block.chainid, "mim");
            if (!onboarding.supportedTokens(usdb)) {
                onboarding.setTokenSupported(usdb, true);
            }
            if (!onboarding.supportedTokens(mim)) {
                onboarding.setTokenSupported(mim, true);
            }
            if (onboarding.owner() != owner) {
                onboarding.transferOwnership(owner);
            }
        }

        vm.stopBroadcast();
    }
}
