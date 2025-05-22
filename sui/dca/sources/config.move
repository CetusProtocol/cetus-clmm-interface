// Copyright (c) Cetus Technology Limited

#[allow(unused_type_parameter, unused_field, unused_const, unused_use)]
module dca::config {
    use std::type_name;
    use std::type_name::TypeName;
    use sui::bag;
    use sui::bag::Bag;
    use sui::balance::Balance;
    use sui::coin;
    use sui::event::emit;
    use sui::table::{Self, Table};
    use sui::transfer::{transfer, share_object, public_transfer};
    use dca::acl;

    // Constructs
    const VERSION: u64 = 1;

    const ACL_KEEPER: u8 = 0;
    const ACL_MANAGER: u8 = 1;
    const ACL_ORACLE: u8 = 2;

    // === Errors ===
    const EPackageVersionDeprecate: u64 = 0;
    const ENoKeeperPermission: u64 = 1;
    const ENoManagerPermision: u64 = 2;
    const ENoOraclePermission: u64 = 3;

    // === Structs ===

    public struct GlobalConfig has key, store {
        id: UID,
        acl: acl::ACL,
        package_version: u64,
        oracle_valid_duration: u64,
        min_cycle_frequency: u64,
        min_cycle_count: u64,
        keeper_threshold: u64,
        whitelist_mode: u8,
        in_coin_whitelist: Table<TypeName, bool>,
        out_coin_whitelist: Table<TypeName, bool>,
    }

    public struct ProtocolFeeVault has key, store {
        id: UID,
        vault: Bag
    }

    // === Events ===

    /// Emit when init dca config module
    public struct InitEvent has copy, drop {
        global_config_id: ID,
        admin_cap_id: ID,
        protocol_fee_vault_id: ID
    }

    /// Emit when set roles
    public struct SetRolesEvent has copy, drop {
        member: address,
        roles: u128,
    }

    /// Emit when add member
    public struct RemoveMemberEvent has copy, drop {
        member: address,
    }

    /// Emit when update package version.
    public struct SetPackageVersionEvent has copy, drop {
        new_version: u64,
        old_version: u64
    }

    /// Emit when set min cycle frequency
    public struct SetMinCycelFrequencyEvent has copy, drop {
        new_min_cycle_frequency: u64,
        old_min_cycle_frequency: u64
    }

    /// Emit when set oracle valid duration
    public struct SetOracleValidDuration has copy, drop {
        new_oracle_valid_duration: u64,
        old_oracle_valid_duration: u64
    }

    /// Emit when set keeper threshold
    public struct SetKeeperThreshold has copy, drop {
        new_keeper_threshold: u64,
        old_keeper_threshold: u64
    }

    /// Emit when set whilitelist mod
    public struct SetWhitelistModeEvent has copy, drop {
        new_whitelist_mode: u8,
        old_whitelist_mode: u8
    }

    /// Emit when add coin type to in coin whitelist
    public struct AddInCoinTypeEvent has copy, drop {
        coin_type: TypeName
    }

    /// Emit when remove coin type to in coin whitelist
    public struct RemoveInCoinTypeEvent has copy, drop {
        coin_type: TypeName
    }

    /// Emit when add coin type to out coin whitelist
    public struct AddOutCoinTypeEvent has copy, drop {
        coin_type: TypeName
    }

    /// Emit when remove coin type to out coin whitelist
    public struct RemoveOutCoinTypeEvent has copy, drop {
        coin_type: TypeName
    }

    /// Emit when claim protocol fee
    public struct ClaimProtocolFee has copy, drop {
        coin_type: TypeName,
        amount: u64
    }

    // === Functions ===

    /// Check package version of the package_version in `GlobalConfig` and VERSION in current package.
    public fun checked_package_version(_config: &GlobalConfig) {
        abort 0
    }

    /// Claim the protocol fee
    public fun claim_fee<CoinType>(
        _config: &GlobalConfig,
        _vault: &mut ProtocolFeeVault,
        _ctx: &mut TxContext
    ) {
        abort 0
    }
}
