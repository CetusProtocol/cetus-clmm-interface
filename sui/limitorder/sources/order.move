// Copyright (c) Cetus Technology Limited

#[allow(lint(share_owned, self_transfer), unused_variable, unused_type_parameter, unused_field, unused_const, unused_use)]
/// This module implements a Limit Order System, which is a financial trading mechanism that
/// allows users to specify the highest rate they are willing to buy or sell a particular asset on the Sui blockchain.
/// A limit order is a conditional request to buy or sell assets, with execution restricted to a specific rate level or
/// better.  Traders can utilize this system on the Sui blockchain to place limit orders.
///
/// Key Features:
/// - Place limit orders to buy or sell assets at specific rate levels.
/// - Traders independently seek matching trade paths on the market to fulfill their orders.
/// - Supports specified trading strategies and asset types.
///
/// This system enables users to have greater control over their trading activities, ensuring that transactions occur at
/// or better than their specified rate levels on the Sui blockchain.  It is a valuable tool for traders operating in
/// various asset types and following specific trading strategies.
module limit_order::limit_order {
    use std::type_name::{Self, TypeName};
    use std::ascii::{Self, String};
    use std::vector;
    use sui::object::{Self, id, ID, UID, uid_to_inner};
    use sui::table::{Self, Table};
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use sui::clock::{Clock, timestamp_ms};
    use sui::transfer;
    use sui::package;
    use sui::event::emit;
    use sui::hash;
    use sui::balance::{Self, Balance, destroy_zero};

    use integer_mate::full_math_u128;

    use move_stl::skip_list_u128::{Self, SkipList};

    use limit_order::config::{Self, GlobalConfig, get_config_deletion_grace_period, get_config_require_flash_loan_auth};

    // === error ===
    const EOrderPoolAlreadyExisted: u64 = 0;
    const ECreatePriceIndexerDuplicateCoinType: u64 = 1;
    const ENoLimitOrderPriceIndexes: u64 = 3;
    const ENoLimitUserOrderIndexes: u64 = 4;
    const EIncorrectFlashLoanAmount: u64 = 5;
    const ELimitOrderExpired: u64 = 6;
    const EIncorrectReceiptAmount: u64 = 7;
    const ELimitOrderNoCancel: u64 = 8;
    const ENoCancelOrderCondition: u64 = 9;
    const EOrderPriceIndexsAlreadyExisted: u64 = 10;
    const EOrderUserIndexsAlreadyExisted: u64 = 11;
    const ELimitOrderNotExpiredForDeletion: u64 = 12;
    const ENoOrderOwnerPermission: u64 = 13;
    const EInvalidTokenTypeOrMinTradeAmount: u64 = 14;
    const EInvalidFlashLoanRate: u64 = 15;
    const ETotalTargetAmountExceed: u64 = 16;
    const EReceiptOrderIdMismatch: u64 = 17;
    const ECreatedTimeGreaterThanExpireTime: u64 = 18;
    const EInsufficientBalance: u64 = 19;

    // === constant ===
    const OVER_TIME_CANCEL: u8 = 1;
    const OWNER_SELF_CANCEL: u8 = 2;
    const SUCCEED_TRADE_CANCEL: u8 = 3;

    /// 10 ** 18
    const PRECISION: u128 = 1000000000000000000;
    const U64_MAX_U128: u128 = 18446744073709551615;
    const U64_MAX_U64: u64 = 18446744073709551615;

    // === struct ===
    /// OneTimeWitness for the module.
    struct LIMIT_ORDER has drop {}

    /// The limit order.
    struct LimitOrder<phantom PayCoin, phantom TargetCoin> has key, store {
        id: UID,
        owner: address,
        rate_order_indexer_id: ID,
        pay_balance: Balance<PayCoin>,
        target_balance: Balance<TargetCoin>,
        total_pay_amount: u64,
        obtained_amount: u64,
        claimed_amount:u64,
        rate: u128,
        created_ts: u64,
        expire_ts: u64,
        canceled_ts: u64,
    }

    /// One swap pair makes up one order pool. It will index orders at different rate levels.
    struct RateOrdersIndexer<phantom PayCoin, phantom TargetCoin> has key, store {
        id: UID,
        /// use SkipList_u128 as indexs structure.
        indexer: SkipList<Table<ID, bool>>,
        size: u64,
    }

    struct RateOrdersIndexerSimpleInfo has store, copy, drop {
        indexer_id: ID,
        indexer_key: ID,
        pay_coin: TypeName,
        target_coin: TypeName,
    }

    struct RateOrdersIndexers has key, store {
        id: UID,
        /// key: pool_key, value: OrderPoolSimpleInfo
        /// pool key is create by hash  pay and target coin type combination
        list: Table<ID, RateOrdersIndexerSimpleInfo>,
        /// the amount about order pools
        size: u64,
    }

    /// It will index orders at different owner address.
    struct UserOrdersIndexer has key, store {
        id: UID,
        indexer: Table<address, Table<ID, bool>>,
        size: u64,
    }

    struct FlashLoanReceipt<phantom TargetCoin> {
        order_id: ID,
        owner: address,
        target_repay_amount: u64,
    }

    // === event ===
    /// Emit when init this module.
    struct InitEvent has copy, drop {
        rate_orders_indexer_id: ID,
        user_orders_indexer_id: ID,
    }

    /// Emit when created a order pool.
    struct RateOrdersIndexerCreatedEvent has copy, store, drop {
        rate_orders_indexer_id: ID,
        pay_coin: String,
        target_coin: String,
    }

    /// Emit when place one order.
    struct OrderPlacedEvent has copy, store, drop {
        order_id: ID,
        owner: address,
        rate_orders_indexer_id: ID,
        pay_coin: String,
        target_coin: String,
        total_pay_amount: u64,
        rate: u128,
        created_ts: u64,
        expire_ts: u64,
    }

    /// Emit when cancel one order.
    struct OrderCanceledEvent has copy, store, drop {
        order_id: ID,
        rate_orders_indexer_id: ID,
        owner: address,
        total_pay_amount: u64,
        remaining_pay_amount: u64,
        remaining_target_amount: u64,
        rate: u128,
        expire_ts: u64,
        cancel_reason: u8,
    }

    /// Emit when flash loan.
    struct FlashLoanEvent has copy, store, drop {
        order_id: ID,
        amount: u64,
        remaining_amount: u64,
        target_repay_amount: u64,
        owner: address,
        borrower: address,
    }

    /// Emit when repoy flash loan.
    struct RepayFlashLoanEvent has copy, store, drop {
        order_id: ID,
        repay_amount: u64,
        repayer: address,
    }

    /// Emit when user claim target coin.
    struct ClaimTargetCoinEvent has copy, store, drop {
        order_id: ID,
        claimed_amount: u64,
    }

    /// Emit when query user indexer event
    struct QueryUserIndexerEvent has copy, store, drop {
        owner: address,
        orders_table_id: ID,
    }

    /// Emit when query rate indexer event
    struct QueryRateIndexerEvent has copy, store, drop {
        rate: u128,
        orders_table_id: ID,
    }

    // === public Functions ===

    public entry fun create_rate_orders_indexer<PayCoin, TargetCoin>(
        config: &GlobalConfig,
        rate_orders_indexers: &mut RateOrdersIndexers,
        clock: &Clock,
        ctx: &mut TxContext,
    ) {
        abort 0
    }

    public entry fun place_limit_order<PayCoin, TargetCoin>(
        config: &GlobalConfig,
        rate_orders_indexer: &mut RateOrdersIndexer<PayCoin, TargetCoin>,
        user_orders_indexer: &mut UserOrdersIndexer,
        pay_coin: Coin<PayCoin>,
        rate: u128,
        expire_ts: u64,
        clock: &Clock,
        ctx: &mut TxContext,
    ) {
        abort 0
    }

    public entry fun create_indexer_and_place_limit_order<PayCoin, TargetCoin>(
        config: &GlobalConfig,
        rate_orders_indexers: &mut RateOrdersIndexers,
        user_orders_indexer: &mut UserOrdersIndexer,
        pay_coin: Coin<PayCoin>,
        rate: u128,
        expire_ts: u64,
        clock: &Clock,
        ctx: &mut TxContext,
    ) {
        abort 0
    }

    public fun flash_loan<PayCoin, TargetCoin>(
        config: &GlobalConfig,
        limit_order: &mut LimitOrder<PayCoin, TargetCoin>,
        amount: u64,
        clock: &Clock,
        ctx: &mut TxContext,
    ): (Coin<PayCoin>, FlashLoanReceipt<TargetCoin>) {
        abort 0
    }

    public fun repay_flash_loan<PayCoin, TargetCoin>(
        config: &GlobalConfig,
        coin: &mut Coin<TargetCoin>,
        limit_order: &mut LimitOrder<PayCoin, TargetCoin>,
        receipt: FlashLoanReceipt<TargetCoin>,
        ctx: &mut TxContext
    ) {
        abort 0
    }

    public fun claim_target_coin<PayCoin, TargetCoin>(
        config: &GlobalConfig,
        limit_order: &mut LimitOrder<PayCoin, TargetCoin>,
        ctx: &mut TxContext,
    ) {
        abort 0
    }

    public fun cancel_order_by_owner<PayCoin, TargetCoin>(
        config: &GlobalConfig,
        rate_orders_indexer: &mut RateOrdersIndexer<PayCoin, TargetCoin>,
        limit_order: &mut LimitOrder<PayCoin, TargetCoin>,
        clock: &Clock,
        ctx: &mut TxContext,
    ) {
        abort 0
    }

    public entry fun get_orders_indexer_by_owner(
        owner: address,
        user_orders_indexer: &UserOrdersIndexer
    ) {
        abort 0
    }

    public entry fun get_orders_indexer_by_rate<PayCoin, TargetCoin>(
        rate: u128,
        rate_orders_indexer: &RateOrdersIndexer<PayCoin, TargetCoin>
    ) {
        abort 0
    }
}
