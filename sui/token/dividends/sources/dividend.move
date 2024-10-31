// This module is designed to dividend the bonus to venfts who hold the xCETUS.
module dividends::dividend {
    use std::option;
    use std::type_name;
    use std::type_name::TypeName;
    use std::vector;
    use cetus::cetus::CETUS;
    use move_stl::linked_table;
    use sui::object::{UID, ID};
    use sui::clock::{Self, Clock};
    use sui::tx_context::TxContext;
    use sui::bag::Bag;
    use sui::vec_map::VecMap;
    use sui::transfer;
    use sui::object;
    use sui::tx_context;
    use sui::bag;
    use sui::coin::Coin;
    use sui::coin;
    use sui::balance::Balance;
    use sui::balance;
    use sui::vec_map;
    use xcetus::xcetus::{ XcetusManager, nfts, VeNftInfo, totol_amount, xcetus_amount, VeNFT, total_holder, XCETUS};
    use xcetus::locking;
    use xcetus::locking::LockUpManager;


    const PACKAGE_VERSION: u64 = 3;
    const ONE_DAY_SECONDS: u64 = 24 * 3600;

    const EBONUS_TYPE_NOT_EXISTS: u64 = 0;
    const EALREADY_SETTLED: u64 = 1;
    const ELAST_PHASE_NOT_FINISH: u64 = 2;
    const EBONUS_TYPE_NOT_SUPPORT: u64 = 3;
    const EDIVIDEND_IS_CLOSE: u64 = 4;
    const EPHASE_NOT_REGISTERED: u64 = 5;
    const ESTART_ERROR: u64 = 6;
    const EPACKAGE_VERSION_DEPRECATE: u64 = 7;
    const EVENFT_HAS_NO_DIVIDEND: u64 = 8;
    const EBALANCE_NOT_ENOUGH: u64 = 9;
    const ESTART_TIME_ERROR: u64 = 10;
    const EBONUS_TYPE_EXISTS: u64 = 11;
    const EAMOUNT_NOT_CHANGE: u64 = 12;
    const EAMOUNT_NOT_ENOUGH: u64 = 13;
    const EMETHOD_DEPRECATED: u64 = 14;
    const EBONUS_IS_ZERO: u64 = 15;

    ///
    struct AdminCap has key, store {
        id: UID
    }

    /// used for settle
    struct SettleCap has key, store {
        id: UID
    }

    /// DividendManager(only one instance)
    struct DividendManager has key {
        id: UID,
        /// Dividend info of every phase.
        dividends: linked_table::LinkedTable<u64, DividendInfo>,
        /// Dividend info of every venft.
        venft_dividends: linked_table::LinkedTable<ID, VeNFTDividendInfo>,
        /// Current bonus type supported.
        bonus_types: vector<TypeName>,
        /// init time
        start_time: u64,
        /// interval day between each settlement phase
        interval_day: u8,
        /// hold the bonus of different types.
        balances: Bag,
        /// status
        is_open: bool,
        package_version: u64
    }

    /// Record the dividend infos of a VeNFT
    struct VeNFTDividendInfo has store, drop {
        /// bonus of every type of every phase. When the bonus is claimed, the record will remove from the vec_map.
        dividends: vec_map::VecMap<u64, vec_map::VecMap<TypeName, u64>>
    }


    /// Global Dividend info.
    struct DividendInfo has store, drop {
        /// register time
        register_time: u64,
        //
        settled_num: u64,
        // is_settle
        is_settled: bool,
        /// bonus types of this phase
        bonus_types: vector<TypeName>,
        /// total bonus of this phase
        bonus: VecMap<TypeName, u64>,
        // bonus redeemed of this phase
        redeemed_num: VecMap<TypeName, u64>,
    }

    /// Events
    struct InitEvent has copy, store, drop {
        admin_id: ID,
        settle_id: ID,
        manager_id: ID,
    }

    struct AddBonusEvent has copy, store, drop {
        type: TypeName
    }

    struct RemoveBonusEvent has copy, store, drop {
        type: TypeName
    }

    struct RegisterEvent has copy, store, drop {
        phase: u64,
        amount: u64
    }

    struct UpdateDividendInfoEvent has copy, store, drop {
        phase: u64,
        amount_before: u64,
        amount: u64
    }

    struct SettleEvent has copy, drop, store {
        phase: u64,
        start: vector<ID>,
        limit: u64,
        next_id: option::Option<ID>,
        count: u64,
    }

    struct RedeemEvent has copy, drop, store {
        venft_id: ID,
        phases: vector<u64>,
        redeemed_nums: vec_map::VecMap<u64, u64>,
        amount: u64
    }

    struct RedeemV2Event has copy, drop, store {
        venft_id: ID,
        type: TypeName,
        amount: u64
    }

    struct ReceiveEvent has copy, drop, store {
        amount: u64
    }

    struct RedeemAllEvent has copy, drop, store {
        receiver: address,
        amount: u64
    }

    struct DividendInfoEvent has copy, drop, store {
        info: vec_map::VecMap<u64, vec_map::VecMap<TypeName, u64>>
    }

    struct SetPackageVersion has copy, drop {
        new_version: u64,
        old_version: u64
    }


    /// Init the AdminCap.
    fun init(_ctx: &mut TxContext) {
        abort 0
    }

    public fun checked_package_version(_m: &DividendManager) {
        abort 0
    }

    public entry fun update_package_version<CoinA>(_: &AdminCap, _manager: &mut DividendManager, _version: u64) {
        abort 0
    }

    public entry fun update_start_time(_: &AdminCap, _manager: &mut DividendManager, _start_time: u64, _clk: &Clock) {
        abort 0
    }

    /// Add bonus type.
    public fun push_bonus<CoinA>(_: &AdminCap, _manager: &mut DividendManager) {
        abort 0
    }

    /// Remove bonus type.
    public fun remove_bonus<CoinA>(_: &AdminCap, _manager: &mut DividendManager) {
        abort 0
    }

    /// Register bonus type at phase
    public fun register_bonus<CoinA>(_: &AdminCap, _m: &mut DividendManager, _phase: u64, _amount: u64, _clk: &Clock) {
        abort 0
    }

    /// Update bonus amount at special phase.
    public entry fun update_bonus<CoinA>(_: &AdminCap, _m: &mut DividendManager, _phase: u64, _amount: u64) {
        abort 0
    }


    /// Every phase ends, the settle is needed do distribute the bonus to Venfts.
    public fun settle(
        _: &SettleCap,
        _m: &mut DividendManager,
        _xcetus_manager: & XcetusManager,
        _phase: u64,
        _start: vector<ID>,
        _limit: u64
    ): option::Option<ID> {
        abort 0
    }

    public fun redeem_v2<CoinA>(
        _m: &mut DividendManager,
        _venft: &mut VeNFT,
        _clk: &Clock,
        _ctx: &mut TxContext
    ) {
        abort 0
    }

    public fun redeem_xtoken(
        _manager: &mut LockUpManager,
        _xcetus_m: &mut XcetusManager,
        _m: &mut DividendManager,
        _venft: &mut VeNFT,
        _clk: &Clock,
        _ctx: &mut TxContext
    ) {
        abort 0
    }

    /// Transfer CoinA to `DividendManager`.
    public fun deposit<CoinA>(_m: &mut DividendManager, _coin: &mut Coin<CoinA>, _amount: u64, _ctx: &mut TxContext) {
        abort 0
    }

    /// Redeem CoinA from DividendManager by the admin.
    public entry fun redeem_extra<CoinA>(
        _: &AdminCap,
        _m: &mut DividendManager,
        _receiver: address,
        _amount: u64,
        _ctx: &mut TxContext
    ) {
        abort 0
    }

    /// Stop the dividend
    public entry fun close(_: &AdminCap, _m: &mut DividendManager) {
        abort 0
    }

    public fun fetch_dividend_info(_m: &DividendManager, _venft_id: ID) {
        abort 0
    }

    fun redeem_token<CoinA>(
        _m: &mut DividendManager,
        _venft: &mut VeNFT,
        _clk: &Clock,
    ): u64 {
        abort 0
    }

    /// Add bonus to venft.
    fun add_dividend(_manager: &mut DividendManager, _venft_id: ID, _phase: u64, _key: TypeName, _amount: u64): bool {
        abort 0
    }

    /// Update the redeemed_num in global DividendInfo.
    fun increase_redeem(_m: &mut DividendManager, _redeem_nums: vec_map::VecMap<u64, u64>, _key: TypeName) {
        abort 0
    }

    /// Take CoinA from `Dividend`.
    fun take<CoinA>(_m: &mut DividendManager, _amount: u64): Balance<CoinA> {
        abort 0
    }

    /// Type generate key.
    fun key<CoinA>(): TypeName {
        abort 0
    }
}
