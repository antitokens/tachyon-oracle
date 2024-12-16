// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../lib/forge-std/src/Test.sol";
import "../src/AntitokenDeltaOracle.sol";
import "../lib/chainlink-brownie-contracts/contracts/src/v0.8/ChainlinkClient.sol";

contract MockLink {
    uint256 private _balance;

    constructor(uint256 initialBalance) {
        _balance = initialBalance;
    }

    function transferAndCall(address, uint256 value, bytes calldata) external view returns (bool) {
        require(_balance >= value, "ERC20: transfer amount exceeds balance");
        return true;
    }

    function transfer(address, uint256 value) external view returns (bool) {
        require(_balance >= value, "ERC20: transfer amount exceeds balance");
        return true;
    }

    function balanceOf(address) external view returns (uint256) {
        return _balance;
    }
}

contract AntitokenDeltaOracleTest is Test {
    AntitokenDeltaOracle public oracle;
    MockLink public mockLink;

    address constant ORACLE_ADDRESS = 0x97Ad69734af26280C2541deA1789146ED7f848e7;
    string constant JOB_ID = "1";

    address public deployer = makeAddr("deployer");

    event ChainlinkRequested(bytes32 indexed id);

    function setUp() public {
        vm.startPrank(deployer);
        mockLink = new MockLink(1000 * 10 ** 18);
        oracle = new AntitokenDeltaOracle(ORACLE_ADDRESS, JOB_ID, address(mockLink));
        vm.stopPrank();
    }

    function testRequestDelta() public {
        // Request delta and capture the request ID
        vm.prank(deployer);
        vm.recordLogs();
        oracle.requestDelta();

        // Get the request ID from the emitted event
        Vm.Log[] memory entries = vm.getRecordedLogs();
        bytes32 requestId;
        for (uint256 i = 0; i < entries.length; i++) {
            if (entries[i].topics[0] == keccak256("ChainlinkRequested(bytes32)")) {
                requestId = bytes32(entries[i].topics[1]);
                break;
            }
        }

        // Mock Chainlink oracle response with the correct request ID
        uint256 expectedDelta = 2500 * 10 ** 6;
        vm.prank(ORACLE_ADDRESS);
        oracle.fulfill(requestId, expectedDelta);

        assertEq(oracle.antitokenDelta(), expectedDelta, "Delta value not correctly updated");
    }

    function testFulfillmentOnlyFromOracle() public {
        bytes32 requestId = bytes32(uint256(1));
        uint256 delta = 2500 * 10 ** 6;

        vm.expectRevert();
        vm.prank(deployer);
        oracle.fulfill(requestId, delta);
    }

    function testRequestDeltaWithoutLink() public {
        MockLink emptyLink = new MockLink(0);

        AntitokenDeltaOracle oracleNoLink = new AntitokenDeltaOracle(ORACLE_ADDRESS, JOB_ID, address(emptyLink));

        vm.expectRevert("ERC20: transfer amount exceeds balance");
        vm.prank(deployer);
        oracleNoLink.requestDelta();
    }
}
