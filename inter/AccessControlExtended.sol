// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./Errors.sol";


contract AccessControlExtended is AccessControl {

    bytes32 public constant GOVERNANCE_ROLE = keccak256("GOVERNANCE");

    constructor (address root) public {
        _setupRole(DEFAULT_ADMIN_ROLE, root);
        _setRoleAdmin(GOVERNANCE_ROLE, DEFAULT_ADMIN_ROLE);
    }

    modifier onlyGovOrAdmin() {
        if(!isAdmin(msg.sender) || !isGovernance(msg.sender)) revert InterswapErrors.AccessError("Restrict to governance or admin");
        _;
    }

    modifier onlyAdmin() {
        if(!isAdmin(msg.sender)) revert InterswapErrors.AccessError("Restrict to admin");
        _;
    }

    modifier onlyGovernance() {
        if(!isGovernance(msg.sender)) revert InterswapErrors.AccessError("Restrict to governance");
        _;
    }

    function isAdmin(address account) public virtual view returns (bool) {
        return hasRole(DEFAULT_ADMIN_ROLE, account);
    }

    function isGovernance(address account) public virtual view returns (bool) {
        return hasRole(GOVERNANCE_ROLE, account);
    }

    function addGovernance(address account) public virtual onlyAdmin {
        grantRole(GOVERNANCE_ROLE, account);
    }

    function addAdmin(address account) public virtual onlyAdmin {
        grantRole(DEFAULT_ADMIN_ROLE, account);
    }

    function removeGovernance(address account) public virtual onlyAdmin {
        revokeRole(GOVERNANCE_ROLE, account);
    }

    function removeAdmin() public virtual onlyAdmin {
        revokeRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }
}