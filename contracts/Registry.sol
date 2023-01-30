// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract UserRegistry is AccessControl {
    struct UserInfo {
        address user;
        uint256 verificationEpoch;
    }

    bytes32 public constant SETTER_ROLE = keccak256("SETTER_ROLE");

    bytes32 public app; // application name
    bytes32 public verificationHash; // node verification hash
    address public nodeAddress; // signatures from this node are valid
    uint256 public immutable verificationPeriod; // the period by which all verifications are invalidated

    mapping(address => UserInfo) public userInfo;

    // ============ Events ============

    event Verified(address user, uint256 epoch);
    event NodeAddressChanged(address nodeAddressOld, address nodeAddressNew);
    event VerificationHashChanged(
        bytes32 verificationHashOld,
        bytes32 verificationHashNew
    );
    event AppChanged(bytes32 appOld, bytes32 appNew);

    // ============ Errors ============

    error InvalidSignature();
    error SignatureExpired();

    constructor(
        string memory app_,
        bytes32 verificationHash_,
        address nodeAddress_,
        uint256 verificationPeriod_,
        address admin_,
        address setter_
    ) {
        app = bytes32(abi.encodePacked(app_));
        verificationHash = verificationHash_;
        nodeAddress = nodeAddress_;
        verificationPeriod = verificationPeriod_;

        _setupRole(DEFAULT_ADMIN_ROLE, admin_);
        _setupRole(SETTER_ROLE, setter_);
    }

    // ============ Public Functions ============

    /// @notice verification status of a user
    /// @param user The user to check
    function isVerified(address user) public view returns (bool) {
        UserInfo memory _userInfo = userInfo[user];
        if (_userInfo.user == address(0)) {
            return false;
        }
        return _userInfo.verificationEpoch == getActiveEpoch();
    }

    /// @notice Get the current epoch
    function getActiveEpoch() public view returns (uint256) {
        return getEpoch(block.timestamp);
    }

    /// @notice Verify a user using a signature obtained from a trusted node
    /// @param user The user to verify
    /// @param verificationTimestamp The timestamp of the verification
    /// @param r The r component of the signature
    /// @param s The s component of the signature
    /// @param v The v component of the signature
    function verify(
        address user,
        uint256 verificationTimestamp,
        bytes32 r,
        bytes32 s,
        uint8 v
    ) public {
        uint256 activeEpoch = getActiveEpoch();

        if (activeEpoch > getEpoch(verificationTimestamp)) {
            revert SignatureExpired();
        }

        bytes32 message = keccak256(
            abi.encodePacked(app, user, verificationHash, verificationTimestamp)
        );

        if (nodeAddress != ecrecover(message, v, r, s)) {
            revert InvalidSignature();
        }

        userInfo[user] = UserInfo(user, activeEpoch);

        emit Verified(user, activeEpoch);
    }

    // ============ Setter Functions ============

    /// @notice Set the node address
    /// @param nodeAddress_ The new node address
    function setNodeAddress(address nodeAddress_) public onlyRole(SETTER_ROLE) {
        emit NodeAddressChanged(nodeAddress, nodeAddress_);
        nodeAddress = nodeAddress_;
    }

    /// @notice Set the verification hash
    /// @param verificationHash_ The new verification hash
    function setVerificationHash(bytes32 verificationHash_)
        public
        onlyRole(SETTER_ROLE)
    {
        emit VerificationHashChanged(verificationHash, verificationHash_);
        verificationHash = verificationHash_;
    }

    /// @notice Set the app
    /// @param app_ The new app
    function setApp(string memory app_) public onlyRole(SETTER_ROLE) {
        bytes32 newApp = bytes32(abi.encodePacked(app_));
        emit AppChanged(app, newApp);
        app = newApp;
    }

    // ============ Internal Functions ============

    /// @notice Get the epoch of a timestamp
    /// @param timestamp The timestamp to get the epoch of
    function getEpoch(uint256 timestamp) internal view returns (uint256) {
        return timestamp / verificationPeriod;
    }
}
