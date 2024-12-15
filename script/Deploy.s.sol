// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../lib/forge-std/src/Script.sol";
import "../src/AntitokenDeltaOracle.sol";

contract DeployOracle is Script {
    function run() external {
        vm.startBroadcast();
        new AntitokenDeltaOracle(
            address(0x0), // Oracle address
            "YourJobId", // Job ID
            address(0x0) // LINK token address
        );
        vm.stopBroadcast();
    }
}
