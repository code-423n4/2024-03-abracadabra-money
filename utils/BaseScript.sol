// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Address} from "openzeppelin-contracts/utils/Address.sol";
import {Vm, VmSafe} from "forge-std/Vm.sol";
import {Toolkit, getToolkit, ChainId} from "utils/Toolkit.sol";
import {Deployer, DeployerDeployment} from "forge-deploy/Deployer.sol";
import {DefaultDeployerFunction} from "forge-deploy/DefaultDeployerFunction.sol";
import {BlastMock} from "./mocks/BlastMock.sol";

abstract contract BaseScript is Script {
    Toolkit internal toolkit = getToolkit();

    // Used to prevent new deployments from being created in case
    // a deployment file doesn't exist.
    bool internal disallowNewDeployment;

    function run() public virtual returns (DeployerDeployment[] memory newDeployments) {
        if (!testing() && block.chainid == ChainId.Blast) {
            vm.etch(address(0x4300000000000000000000000000000000000002), address(new BlastMock()).code);
            vm.allowCheatcodes(address(0x4300000000000000000000000000000000000002));
        }

        Address.functionDelegateCall(address(this), abi.encodeWithSignature("deploy()"));
        return toolkit.deployer().newDeployments();
    }

    function setTesting(bool _testing) public {
        toolkit.setTesting(_testing);
    }

    function setNewDeploymentEnabled(bool _enabled) public {
        disallowNewDeployment = !_enabled;
    }

    function testing() internal view returns (bool) {
        return toolkit.testing();
    }

    function deploy(string memory deploymentName, string memory artifactName) internal returns (address instance) {
        return deploy(deploymentName, artifactName, "");
    }

    function deploy(string memory deploymentName, string memory artifact, bytes memory args) internal returns (address deployed) {
        Deployer deployer = toolkit.deployer();
        deploymentName = toolkit.prefixWithChainName(block.chainid, deploymentName);

        if (toolkit.testing()) {
            deployer.ignoreDeployment(deploymentName);
        }

        if (deployer.has(deploymentName)) {
            return deployer.getAddress(deploymentName);
        }

        require(toolkit.testing() || !disallowNewDeployment, "BaseScript: new deployments are disabled");
        
        bytes memory bytecode = vm.getCode(artifact);
        bytes memory data = bytes.concat(bytecode, args);
        (bool prankActive, address prankAddress) = deployer.prankStatus();

        if (prankActive) {
            if (prankAddress != address(0)) {
                vm.prank(prankAddress);
            } else {
                vm.prank(address(0));
            }
        }

        assembly {
            deployed := create(0, add(data, 0x20), mload(data))
        }

        if (deployed == address(0)) {
            revert(string.concat("Failed to deploy ", deploymentName));
        }

        // No need to store anything in testing environment
        if (!toolkit.testing()) {
            (VmSafe.CallerMode callerMode, , ) = vm.readCallers();
            require(callerMode != VmSafe.CallerMode.Broadcast, "BaseScript: unexpected broadcast mode");
            if (callerMode == VmSafe.CallerMode.RecurrentBroadcast) {
                vm.stopBroadcast();
            }
            deployer.save(deploymentName, deployed, artifact, args, bytecode);
            if (callerMode == VmSafe.CallerMode.RecurrentBroadcast) {
                vm.startBroadcast();
            }
        }
    }
}
