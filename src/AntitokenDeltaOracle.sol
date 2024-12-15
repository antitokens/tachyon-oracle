// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../lib/chainlink-brownie-contracts/contracts/src/v0.8/ChainlinkClient.sol";

contract AntitokenDeltaOracle is ChainlinkClient {
    using Chainlink for Chainlink.Request;

    uint256 public AntitokenDelta; // Stores the fetched Antitoken delta
    address private oracle; // Chainlink Oracle address
    bytes32 private jobId; // Chainlink job ID
    uint256 private fee; // LINK fee for the request

    // Events
    event DeltaUpdated(uint256 delta);
    event RequestFailed(bytes32 requestId);

    constructor(address _oracle, string memory _jobId, address _link) {
        _setChainlinkToken(_link);
        oracle = _oracle;
        jobId = stringToBytes32(_jobId);
        fee = 0.1 * 10 ** 18; // 0.1 LINK
    }

    function requestAntitokenDelta(
        string memory _apiUrl,
        string memory _jsonPath
    ) public {
        Chainlink.Request memory req = _buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );

        req._add("get", _apiUrl); // API endpoint for Antitoken delta
        req._add("path", _jsonPath); // JSON path to extract the delta
        _sendChainlinkRequestTo(oracle, req, fee);
    }

    function fulfill(
        bytes32 _requestId,
        uint256 _delta
    ) public recordChainlinkFulfillment(_requestId) {
        AntitokenDelta = _delta;
        emit DeltaUpdated(_delta);
    }

    function stringToBytes32(
        string memory source
    ) private pure returns (bytes32 result) {
        bytes memory tempBytes = bytes(source);
        if (tempBytes.length == 0) return 0x0;
        assembly {
            result := mload(add(source, 32))
        }
    }
}
