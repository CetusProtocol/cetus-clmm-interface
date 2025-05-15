// Copyright © Cetus Technology Limited

#[allow(unused_const, unused_field)]
/// Fork @https://github.com/pentagonxyz/movemate.git
///
/// `acl` is a simple access control module, where `member` represents a member and `role` represents a type
/// of permission. A member can have multiple permissions.
module limit_order::acl {

    /// @dev When attempting to add/remove a role >= 128.
    const ERoleNumberTooLarge: u64 = 0;

    /// @dev Maps addresses to `u128`s with each bit representing the presence of (or lack of) each role.
    struct ACL has store {
        permissions: vector<u8> // Changed to vector, as interfaces should not include specific implementations
    }
}
