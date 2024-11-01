// Copyright (c) Cetus Technology Limited

#[allow(unused_field, unused_const, unused_use)]
/// Fork @https://github.com/pentagonxyz/movemate.git
///
/// `acl` is a simple access control module, where `member` represents a member and `role` represents a type
/// of permission. A member can have multiple permissions.
module cetus_dca::acl {
    use move_stl::linked_table::{Self, LinkedTable};
    use std::option::is_some;

    /// @dev When attempting to add/remove a role >= 128.
    const ERoleNumberTooLarge: u64 = 0;

    /// @dev Maps addresses to `u128`s with each bit representing the presence of (or lack of) each role.
    public struct ACL has store {
        permissions: LinkedTable<address, u128>
    }

    public struct Member has store, drop, copy {
        address: address,
        permission: u128
    }

    /// @notice Create a new ACL (access control list).
    public fun new(ctx: &mut TxContext): ACL {
        abort 0
    }

    /// @notice Check if a member has a role in the ACL.
    public fun has_role(acl: &ACL, member: address, role: u8): bool {
        abort 0
    }

    /// @notice Set all roles for a member in the ACL.
    /// @param permissions Permissions for a member, represented as a `u128` with each bit representing the presence of (or lack of) each role.
    public fun set_roles(acl: &mut ACL, member: address, permissions: u128) {
        abort 0
    }

    /// @notice Add a role for a member in the ACL.
    public fun add_role(acl: &mut ACL, member: address, role: u8) {
        abort 0
    }

    /// @notice Revoke a role for a member in the ACL.
    public fun remove_role(acl: &mut ACL, member: address, role: u8) {
        abort 0
    }

    /// Remove all roles of member.
    public fun remove_member(acl: &mut ACL, member: address) {
        abort 0
    }

    /// Get all members.
    public fun get_members(acl: &ACL): vector<Member> {
        abort 0
    }

    /// Get the permission of member by addresss.
    public fun get_permission(acl: &ACL, address: address): u128 {
        abort 0
    }
}
