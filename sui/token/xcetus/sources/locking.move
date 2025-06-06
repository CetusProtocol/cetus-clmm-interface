#[allow(unused_use, unused_field, unused_const)]
// This module works with xcetus module to provide lock of xCETUS.
// If you want to convert XCETUS back to CETUS, you have to lock it for some times.
// If the lock time ends, you can redeem CETUS to your address, and the xCETUS will be burned.
// You can also cancel the lock before lock time ends.
// The convert of CETUS to xCETUS is provided.
module xcetus::locking {
    use std::type_name::TypeName;
    use sui::object::{UID, ID};
    use sui::balance::Balance;
    use sui::tx_context::TxContext;
    use sui::coin::Coin;
    use sui::clock::Clock;
    use move_stl::linked_table;
    use xcetus::xcetus::{VeNFT, XcetusManager};
    use xcetus::lock_coin::LockedCoin;
    use cetus::cetus::CETUS;

    const ONE_DAY_SECONDS: u64 = 24 * 3600;
    const EXCHANGE_RATE_MULTIPER: u128 = 1000;
    const REDEEM_NUM_MULTIPER: u128 = 100000000000;
    const PACKAGE_VERSION: u64 = 1;

    // Errors
    const EINIT_CONFIG_ERROR: u64 = 0;
    const EBALANCE_NOT_ENOUGH: u64 = 1;
    const ELOCK_DAY_ERROR: u64 = 2;
    const EREDEMM_AMOUNT_ERROR: u64 = 3;
    const EVENFT_NOT_MATCH_WITH_LOCK: u64 = 4;
    const EALREADY_UNLOCK: u64 = 5;
    const EADMIN_REDEEM_ERROR: u64 = 6;
    const ETREASURY_MANAGER_ERROR: u64 = 7;
    const EPACKAGE_VERSION_DEPRECATE: u64 = 8;

    struct AdminCap has key, store {
        id: UID
    }

    /// Manager the lock to the xCETUS.
    struct LockUpManager has key {
        id: UID,
        balance: Balance<CETUS>,
        treasury_manager: address,
        extra_treasury: Balance<CETUS>,
        /// lock_id -> LockInfo
        lock_infos: linked_table::LinkedTable<ID, LockInfo>,
        type_name: TypeName,
        min_lock_day: u64,
        max_lock_day: u64,
        min_percent_numerator: u64,
        max_percent_numerator: u64,
        //package version
        package_version: u64,
    }

    /// The lock info.
    struct LockInfo has store, drop {
        venft_id: ID,
        lock_id: ID,
        xcetus_amount: u64,
        cetus_amount: u64,
    }

    /// Events
    struct ConvertEvent has copy, store, drop {
        venft_id: ID,
        amount: u64,
        lock_manager: ID,
    }

    struct RedeemLockEvent has copy, store, drop {
        lock_manager: ID,
        venft_id: ID,
        amount: u64,
        lock_day: u64,
        cetus_amount: u64,
    }

    struct CancelRedeemEvent has copy, drop, store {
        lock_manager: ID,
        venft_id: ID,
        locked_coin: ID,
    }

    struct RedeemEvent has copy, drop, store {
        lock_manager: ID,
        venft_id: ID,
        locked_coin: ID,
        cetus_amount: u64,
        xcetus_amount: u64
    }

    struct RedeemAllEvent has copy, drop, store {
        lock_manager: ID,
        receiver: address,
        amount: u64,
    }

    struct LOCKING has drop {}

    public fun checked_package_version(_m: &LockUpManager) {
        abort 0
    }

    /// Convert from CETUS to xCETUS.
    /// The mint of xCETUS needs to save same amount of CETUS in LockManager.
    public fun convert(
        _: &mut LockUpManager,
        _: &mut XcetusManager,
        _: vector<Coin<CETUS>>,
        _: u64,
        _: &mut VeNFT,
        _: &mut TxContext
    ) {
        abort 0
    }

    /// Convert xCETUS back to CETUS.
    /// The calculated amount of CETUS will wrap in LockedCoin object and give to user.
    /// the state of venftinfo will be updated.
    public fun redeem_lock(
        _: &mut LockUpManager,
        _: &mut XcetusManager,
        _: &mut VeNFT,
        _: u64,
        _: u64,
        _: &Clock,
        _: &mut TxContext
    ) {
        abort 0
    }


    /// Cancel the redeem lock.
    /// The CETUS will be send back to LockManger, LockedCoin will be destroyed. the state related to xCETUS will be updated.
    public fun cancel_redeem_lock(
        _: &mut LockUpManager,
        _: &mut XcetusManager,
        _: &mut VeNFT,
        _: LockedCoin<CETUS>,
        _: &Clock,
    ) {
        abort 0
    }

    /// When the lock time is ends, the CETUS can be redeemed.
    public fun redeem(
        _: &mut LockUpManager,
        _: &mut XcetusManager,
        _: &mut VeNFT,
        _: LockedCoin<CETUS>,
        _: &Clock,
        _: &mut TxContext
    ) {
        abort 0
    }

    /// Mint VeNFT and convert.
    public fun mint_and_convert(
        _: &mut LockUpManager,
        _: &mut XcetusManager,
        _: vector<Coin<CETUS>>,
        _: u64,
        _: &mut TxContext
    ) {
        abort 0
    }
}

