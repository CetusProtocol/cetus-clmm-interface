#[allow(unused_type_parameter, unused_field, unused_const)]
module stable_farming::config {
    use sui::object::{ID, UID};
    use sui::tx_context::TxContext;
    use sui::table::Table;

    use stable_farming::acl;


    /// The acl roles of stable farming
    const ACL_POOL_MANAGER: u8 = 0;
    const ACL_REWARDER_MANAGER: u8 = 1;

    const VERSION: u64 = 1;

    // ========================= Errors ==========================
    const ENoPoolManagerPermission: u64 = 1;
    const ENoRewarderManagerPermission: u64 = 2;
    const EPackageVersionDeprecate: u64 = 3;

    // ========================= Structs =========================
    /// The admin cap of stable farming module
    struct AdminCap has key, store {
        id: UID
    }

    /// The operator cap of stable farming module
    struct OperatorCap has key {
        id: UID
    }

    /// The global config of stable farming module 
    struct GlobalConfig has key, store {
        id: UID,
        _acl: acl::ACL,
        _acceleration_factor: Table<ID, u8>,
        _package_version: u64
    }

    // ========================= Events ===========================
    /// Emit when module init
    struct InitConfigEvent has copy, drop {
        _admin_cap_id: ID,
        _global_config_id: ID
    }

    /// Emit when add a operator
    struct AddOperatorEvent has copy, drop {
        _operator_cap_id: ID,
        _recipient: address,
        _roles: u128
    }

    /// Emit when set roles
    struct SetRolesEvent has copy, drop {
        _member: address,
        _roles: u128,
    }

    /// Emit when add member a role
    struct AddRoleEvent has copy, drop {
        _member: address,
        _role: u8,
    }

    /// Emit when remove member a role
    struct RemoveRoleEvent has copy, drop {
        _member: address,
        _role: u8
    }

    /// Emit when add member
    struct RemoveMemberEvent has copy, drop {
        _member: address,
    }

    /// Emit when update package version.
    struct SetPackageVersion has copy, drop {
        _new_version: u64,
        _old_version: u64
    }

    #[allow(unused_function)]
    fun init(_ctx: &mut TxContext) {
        abort 0
    }

    /// Add a operator
    public fun add_operator(
        _: &AdminCap,
        _config: &mut GlobalConfig,
        _roles: u128,
        _recipient: address,
        _ctx: &mut TxContext
    ) {
        abort 0
    }

    public fun set_roles(_: &AdminCap, _config: &mut GlobalConfig, _member: address, _roles: u128) {
        abort 0
    }

    public fun add_role(_: &AdminCap, _config: &mut GlobalConfig, _member: address, _role: u8) {
        abort 0
    }

    public fun remove_role(_: &AdminCap, _config: &mut GlobalConfig, _member: address, _role: u8) {
        abort 0
    }

    public fun remove_member(_: &AdminCap, _config: &mut GlobalConfig, _member: address) {
        abort 0
    }

    public fun set_package_version(_: &AdminCap, _config: &mut GlobalConfig, _version: u64) {
        abort 0
    }

    public fun get_members(_config: &GlobalConfig): vector<acl::Member> {
        abort 0
    }

    public fun check_pool_manager_role(_config: &GlobalConfig, _member: address) {
        abort 0
    }

    public fun check_rewarder_manager_role(_config: &GlobalConfig, _member: address) {
        abort 0
    }

    public fun checked_package_version(_config: &GlobalConfig) {
        abort 0
    }

    public fun package_version(): u64 {
        abort 0
    }
}
