#[allow(unused_type_parameter, unused_field, unused_const, unused_use)]
module cetus_dca::config {
    use std::type_name;
    use std::type_name::TypeName;
    use sui::bag;
    use sui::bag::Bag;
    use sui::balance::Balance;
    use sui::coin;
    use sui::event::emit;
    use sui::table::{Self, Table};
    use sui::transfer::{transfer, share_object, public_transfer};
    use cetus_dca::acl;

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
    public struct AdminCap has key, store {
        id: UID
    }

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
    public fun checked_package_version(config: &GlobalConfig) {
        abort 0
    }

    /// Update the package version.
    public fun update_package_version(config: &mut GlobalConfig, _: &AdminCap, version: u64) {
        abort 0
    }

    public fun package_version(): u64 {
        abort 0
    }

    /// Set role for member.
    public fun set_roles(config: &mut GlobalConfig, _: &AdminCap, member: address, roles: u128) {
        abort 0
    }

    /// Remove a member from ACL.
    public fun remove_member(config: &mut GlobalConfig, _: &AdminCap, member: address) {
        abort 0
    }

    /// Get all members in ACL.
    public fun get_members(config: &GlobalConfig): vector<acl::Member> {
        abort 0
    }

    /// Set whitelist mode
    public fun set_whitelist_mode(config: &mut GlobalConfig, whitelist_mode: u8, ctx: &TxContext) {
        abort 0
    }

    /// Set min cycle frequency
    public fun set_min_cycle_frequency(config: &mut GlobalConfig, min_cycle_frequency: u64, ctx: &TxContext) {
        abort 0
    }

    public fun set_oracle_valid_duration(config: &mut GlobalConfig, oracle_valid_duration: u64, ctx: &TxContext) {
        abort 0
    }

    /// Add in coin type to in coin whitelist
    public fun add_in_coin_type<InCoin>(config: &mut GlobalConfig, ctx: &TxContext) {
        abort 0
    }

    /// Remove in coin type from in coin whitelist
    public fun remove_in_coin_type<InCoin>(config: &mut GlobalConfig, ctx: &TxContext) {
        abort 0
    }

    /// Add in coin type to in coin whitelist
    public fun add_out_coin_type<OutCoin>(config: &mut GlobalConfig, ctx: &TxContext) {
        abort 0
    }

    /// Remove in coin type from in coin whitelist
    public fun remove_out_coin_type<OutCoin>(config: &mut GlobalConfig, ctx: &TxContext) {
        abort 0
    }

    /// Set keeper threshold
    public fun set_keeper_threshold(config: &mut GlobalConfig, keeper_threshold: u64, ctx: &TxContext) {
        abort 0
    }

    /// Receive protocol fee
    public fun receive_fee<CoinType>(vault: &mut ProtocolFeeVault, fee: Balance<CoinType>) {
        abort 0
    }

    /// Claim the protocol fee
    public fun claim_fee<CoinType>(
        config: &GlobalConfig,
        vault: &mut ProtocolFeeVault,
        ctx: &mut TxContext
    ) {
        abort 0
    }

    // === View Functions ===

    public fun whitelist_mode(config: &GlobalConfig) : u8 {
        abort 0
    }

    public fun min_cycle_frequency(config: &GlobalConfig): u64 {
        abort 0
    }

    public fun min_cycle_count(config: &GlobalConfig) : u64 {
        abort 0
    }

    public fun is_coin_allow<InCoin, OutCoin>(config: &GlobalConfig) : bool {
        abort 0
    }

    public fun checked_keeper(config: &GlobalConfig, addr: address) {
        abort 0
    }

    public fun checked_oracle(config: &GlobalConfig, addr: address) {
        abort 0
    }

    public fun oracle_valid_duration(config: &GlobalConfig): u64 {
        abort 0
    }

    public fun keeper_threshold(config: &GlobalConfig): u64 {
        abort 0
    }
}
