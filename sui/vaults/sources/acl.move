// Copyright (c) Cetus Technology Limited

/// Fork @https://github.com/pentagonxyz/movemate.git
///
/// `acl` is a simple access control module, where `member` represents a member and `role` represents a type
/// of permission. A member can have multiple permissions.
#[allow(unused_type_parameter, unused_field, unused_const)]
module vaults::acl {

    use move_stl::linked_table::{LinkedTable};

    const MAX_U128: u128 = 340282366920938463463374607431768211455;

    /// @dev When attempting to add/remove a role >= 128.
    const ERoleNumberTooLarge: u64 = 0;
    const EMemberNotExists: u64 = 1;

    /// @dev Maps addresses to `u128`s with each bit representing the presence of (or lack of) each role.
    struct ACL has store {
        permissions: LinkedTable<address, u128>
    }

    struct Member has store, drop, copy {
        address: address,
        permission: u128
    }
}
