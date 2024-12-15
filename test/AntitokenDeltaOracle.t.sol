// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/AntitokenDeltaOracle.sol";

contract AntitokenDeltaOracleTest is Test {
    AntitokenDeltaOracle public oracle;

    function setUp() public {
        oracle = new AntitokenDeltaOracle(
            address(0x0),
            "YourJobId",
            address(0x0)
        );
    }

    function testRequestAntitokenDelta() public {
        oracle.requestAntitokenDelta(
            "https://api.antitoken.pro",
            "delta"
        );

        // Mock Chainlink fulfillment here
        oracle.fulfill(bytes32(0), 2500 * 10 ** 18);
        assertEq(oracle.AntitokenDelta(), 2500 * 10 ** 18);
    }
}
