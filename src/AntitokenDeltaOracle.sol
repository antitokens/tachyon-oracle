// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../lib/chainlink-brownie-contracts/contracts/src/v0.8/ChainlinkClient.sol";

contract AntitokenDeltaOracle is ChainlinkClient {
    using Chainlink for Chainlink.Request;

    uint256 public antitokenDelta;
    address private immutable oracle;
    bytes32 private immutable jobId;
    uint256 private constant fee = 0.01 * 10 ** 18; // 0.01 LINK

    event DeltaUpdated(uint256 delta);

    constructor(address _oracle, string memory _jobId, address _link) {
        if (_oracle == address(0) || _link == address(0)) revert();
        _setChainlinkToken(_link);
        oracle = _oracle;
        jobId = stringToBytes32(_jobId);
    }

    function requestDelta() public {
        Chainlink.Request memory req = _buildChainlinkRequest(jobId, address(this), this.fulfill.selector);

        _sendChainlinkRequestTo(oracle, req, fee);
    }

    function fulfill(bytes32 _requestId, uint256 _delta) public recordChainlinkFulfillment(_requestId) {
        antitokenDelta = _delta;
        emit DeltaUpdated(_delta);
    }

    function stringToBytes32(string memory source) private pure returns (bytes32 result) {
        bytes memory tempBytes = bytes(source);
        if (tempBytes.length == 0) return 0x0;
        assembly {
            result := mload(add(source, 32))
        }
    }
}
