#[allow(unused_use, unused_field)]
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
    use xcetus::lock_coin;
    use xcetus::xcetus::{VeNFT, XcetusManager, available_value};
    use xcetus::lock_coin::{LockedCoin, unlock_coin, lock_time, destory_lock};
    use xcetus::utils::{now_timestamp, merge_coins};
    use cetus::cetus::CETUS;

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
    struct InitEvent has copy, store, drop {
        admin_id: ID,
        publisher_id: ID,
        display_id: ID,
    }

    struct InitializeEvent has copy, drop, store {
        min_lock_day: u64,
        max_lock_day: u64,
        min_percent_numerator: u64,
        max_percent_numerator: u64,
        lock_manager: ID,
        cetus_type: TypeName,
    }

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

    struct SetPackageVersion has copy, drop {
        new_version: u64,
        old_version: u64
    }

    struct LOCKING has drop {}

    public fun checked_package_version(_m: &LockUpManager) {
        abort 0
    }

    /// Convert from CETUS to xCETUS.
    /// The mint of xCETUS needs to save same amount of CETUS in LockManager.
    public fun convert(
        _manager: &mut LockUpManager,
        _xcetus_m: &mut XcetusManager,
        _coins: vector<Coin<CETUS>>,
        _amount: u64,
        _venft: &mut VeNFT,
        _ctx: &mut TxContext
    ) {
        abort 0
    }

    /// Convert xCETUS back to CETUS.
    /// The calculated amount of CETUS will wrap in LockedCoin object and give to user.
    /// the state of venftinfo will be updated.
    public fun redeem_lock(
        _manager: &mut LockUpManager,
        _xcetus_m: &mut XcetusManager,
        _venft: &mut VeNFT,
        _amount: u64,
        _lock_day: u64,
        _clk: &Clock,
        _ctx: &mut TxContext
    ) {
        abort 0
    }


    /// Cancel the redeem lock.
    /// The CETUS will be send back to LockManger, LockedCoin will be destoryed. the state related to xCETUS will be updated.
    public fun cancel_redeem_lock(
        _manager: &mut LockUpManager,
        _xcetus_m: &mut XcetusManager,
        _venft: &mut VeNFT,
        _lock: LockedCoin<CETUS>,
        _clk: &Clock,
    ) {
        abort 0
    }

    /// When the lock time is ends, the CETUS can be redeemed.
    public fun redeem(
        _manager: &mut LockUpManager,
        _xcetus_m: &mut XcetusManager,
        _venft: &mut VeNFT,
        _lock: LockedCoin<CETUS>,
        _clock: &Clock,
        _ctx: &mut TxContext
    ) {
        abort 0
    }

    /// Mint VeNFT and convert.
    public fun mint_and_convert(
        _manager: &mut LockUpManager,
        _xcetus_m: &mut XcetusManager,
        _coins: vector<Coin<CETUS>>,
        _amount: u64,
        _ctx: &mut TxContext
    ) {
        abort 0
    }
}

