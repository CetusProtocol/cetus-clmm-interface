// Copyright (c) Cetus Technology Limited

#[allow(unused_field, unused_const)]
/// Fork @https://github.com/pentagonxyz/movemate.git
///
/// `acl` is a simple access control module, where `member` represents a member and `role` represents a type
/// of permission. A member can have multiple permissions.
module cetus_dca::acl {

    use move_stl::linked_table::LinkedTable;

    /// @dev When attempting to add/remove a role >= 128.
    const ERoleNumberTooLarge: u64 = 0;

    /// @dev Maps addresses to `u128`s with each bit representing the presence of (or lack of) each role.
    public struct ACL has store {
        permissions: LinkedTable<address, u128>
    }
}
