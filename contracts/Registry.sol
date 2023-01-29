// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract VerifySignature {
    struct UserInfo {
        address User;
        uint256 verificationEpoch;
    }

    bytes32 public app; // application name
    bytes32 public verificationHash; // node verification hash
    address public nodeAddress; // signatures from this node are valid

    uint256 public verificationPeriod; // the period by which all verifications are invalidated
    mapping(address => UserInfo) public userInfo;

    constructor(
        bytes32 app_,
        bytes32 verificationHash_,
        address nodeAddress_
    ) {}

    function getActiveEpoch() public view returns (uint256) {
        return block.timestamp / verificationPeriod;
    }

    function verify(address user) public pure returns (address) {
        bytes32 app = bytes32(abi.encodePacked("unitapTest"));
        bytes32 verificationHash = 0x501d93d62115b06f5ceb1dd25f831dc7bbf0478ce81303c1b3a2172cdff6e465;
        address addr = 0xB10f8E218A9cD738b0F1E2f7169Aa3c0897F2d83;
        uint256 timestamp = 1672834200;

        bytes32 r = 0xca5bf2a09abff8a3b154645e40b54a4b0c443c4ddef3a4a9967af1e94ddef422;
        bytes32 s = 0x01dd9f94456a248183699798a0f9a175277f0154574c6cb64ee638226abc0d66;
        uint8 v = 28;

        bytes32 message = keccak256(
            abi.encodePacked(app, addr, verificationHash, timestamp)
        );
        address signer = ecrecover(message, v, r, s);

        return signer;
    }
}
