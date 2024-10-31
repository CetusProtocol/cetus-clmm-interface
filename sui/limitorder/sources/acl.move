// Copyright © Cetus Technology Limited

#[allow(unused_field, unused_const, unused_use)]
/// Fork @https://github.com/pentagonxyz/movemate.git
///
/// `acl` is a simple access control module, where `member` represents a member and `role` represents a type
/// of permission. A member can have multiple permissions.
module limit_order::acl {
    use std::vector;
    use std::option::{Self, is_some};

    use sui::tx_context::TxContext;

    use move_stl::linked_table::{Self, LinkedTable};

    /// @dev When attempting to add/remove a role >= 128.
    const ERoleNumberTooLarge: u64 = 0;

    const MAX_U128: u128 = 340282366920938463463374607431768211455;

    /// @dev Maps addresses to `u128`s with each bit representing the presence of (or lack of) each role.
    struct ACL has store {
        permissions: vector<u8> // Changed to vector, as interfaces should not include specific implementations
    }

    struct Member has store, drop, copy {
        address: address,
        permission: u128
    }

    /// @notice Create a new ACL (access control list).
    public fun new(_ctx: &mut TxContext): ACL {
        abort 0
    }

    /// @notice Check if a member has a role in the ACL.
    public fun has_role(_acl: &ACL, _member: address, _role: u8): bool {
        abort 0
    }

    /// @notice Set all roles for a member in the ACL.
    /// @param _permissions Permissions for a member, each bit representing the presence of (or lack of) each role.
    public fun set_roles(_acl: &mut ACL, _member: address, _permissions: u128) {
        abort 0
    }

    /// @notice Add a role for a member in the ACL.
    public fun add_role(_acl: &mut ACL, _member: address, _role: u8) {
        abort 0
    }

    /// @notice Revoke a role for a member in the ACL.
    public fun remove_role(_acl: &mut ACL, _member: address, _role: u8) {
        abort 0
    }

    /// @notice Remove all roles of a member.
    public fun remove_member(_acl: &mut ACL, _member: address) {
        abort 0
    }

    /// @notice Get all members.
    public fun get_members(_acl: &ACL): vector<Member> {
        abort 0
    }

    /// @notice Get the permission of a member by address.
    public fun get_permission(_acl: &ACL, _address: address): u128 {
        abort 0
    }
}
