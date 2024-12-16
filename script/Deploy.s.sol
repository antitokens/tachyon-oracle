// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../lib/forge-std/src/Script.sol";
import "../src/AntitokenDeltaOracle.sol";

contract DeployOracle is Script {
    // Mumbai Testnet addresses
    address constant ORACLE_ADDRESS = 0x97Ad69734af26280C2541deA1789146ED7f848e7;
    address constant LINK_TOKEN = 0x84b9B910527Ad5C03A9Ca831909E21e236EA7b06;
    string constant JOB_ID = "1"; // Replace with your actual job ID

    function run() external {
        vm.startBroadcast();

        // Deploy the oracle contract
        new AntitokenDeltaOracle(ORACLE_ADDRESS, JOB_ID, LINK_TOKEN);
        vm.stopBroadcast();
    }
}
