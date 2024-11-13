#[allow(unused_type_parameter, unused_field, unused_const, unused_use)]
// This module is designed to dividend the bonus to venfts who hold the xCETUS.
module dividends::dividend {
    use std::type_name::TypeName;
    use move_stl::linked_table;
    use sui::object::{UID, ID};
    use sui::clock::Clock;
    use sui::tx_context::TxContext;
    use sui::bag::Bag;
    use sui::vec_map::VecMap;
    use sui::table::Table;
    use sui::vec_map;
    use xcetus::xcetus::VeNFT;


    const ONE_DAY_SECONDS: u64 = 24 * 3600;

    const EBONUS_TYPE_NOT_EXISTS: u64 = 0;
    const EALREADY_SETTLED: u64 = 1;
    const ELAST_PHASE_NOT_FINISH: u64 = 2;
    const EBONUS_TYPE_NOT_SUPPORT: u64 = 3;
    const EDIVIDEND_IS_CLOSE: u64 = 4;
    const EPHASE_NOT_REGISTERED: u64 = 5;
    const ESTART_ERROR: u64 = 6;
    const EPACKAGE_VERSION_DEPRECATE: u64 = 7;
    #[allow(unused_const)]
    const EVENFT_HAS_NO_DIVIDEND: u64 = 8;
    const EBALANCE_NOT_ENOUGH: u64 = 9;
    #[allow(unused_const)]
    const ESTART_TIME_ERROR: u64 = 10;
    const EBONUS_TYPE_EXISTS: u64 = 11;
    const EAMOUNT_NOT_CHANGE: u64 = 12;
    const EAMOUNT_NOT_ENOUGH: u64 = 13;
    const EMETHOD_DEPRECATED: u64 = 14;
    const EBONUS_IS_ZERO: u64 = 15;
    const EREGISTER_ALREADY: u64 = 16;

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

    struct VeNFTDividends has key {
        id: UID,
        venft_dividends: linked_table::LinkedTable<ID, VeNFTDividendInfoV2>
    }

    struct VeNFTDividendInfoV2 has store {
        /// bonus of every type of every phase. When the bonus is claimed, the record will remove from the vec_map.
        dividends: Table<u64, vec_map::VecMap<TypeName, u64>>
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

    struct RedeemV3Event has copy, drop, store {
        venft_id: ID,
        type: TypeName,
        amount: u64
    }

    struct RedeemAllEvent has copy, drop, store {
        receiver: address,
        amount: u64
    }

    struct DividendInfoEvent has copy, drop, store {
        info: vec_map::VecMap<u64, vec_map::VecMap<TypeName, u64>>
    }

    public fun redeem_v2<CoinA>(
        _: &mut DividendManager,
        _: &mut VeNFT,
        _: &Clock,
        _: &mut TxContext
    ) {
        abort 0
    }

    public fun redeem_v3<CoinA>(
        _: &mut DividendManager,
        _: &mut VeNFTDividends,
        _: vector<u64>,
        _: &mut VeNFT,
        _: &Clock,
        _: &mut TxContext
    ) {
        abort 0
    }

    public fun fetch_dividend_info(_: &DividendManager, _: ID) {
        abort 0
    }

    public fun fetch_dividend_info_v2(_: &DividendManager, _: &VeNFTDividends, _: ID) {
        abort 0
    }
}
