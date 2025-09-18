// Copyright (c) Cetus Technology Limited

#[allow(unused_type_parameter, unused_field, unused_const, unused_use)]
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

    use limit_order::config::{Self, GlobalConfig};

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

    /// Represents a limit order.
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

    /// Simplified information about an order pool.
    struct RateOrdersIndexerSimpleInfo has store, copy, drop {
        indexer_id: ID,
        indexer_key: ID,
        pay_coin: TypeName,
        target_coin: TypeName,
    }

    /// Indexes order pools by the combination of pay and target coin types.
    struct RateOrdersIndexers has key, store {
        id: UID,
        /// key: pool_key, value: OrderPoolSimpleInfo
        /// pool key is create by hash  pay and target coin type combination
        list: Table<ID, RateOrdersIndexerSimpleInfo>,
        /// the amount about order pools
        size: u64,
    }

    /// Indexes orders by different owner addresses.
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

    /// Creates a new rate orders indexer.
    /// When a new order pool is created, it will be indexed by the combination of pay and target coin types.
    /// Parameters:
    /// - `_config`: Reference to the global configuration.
    /// - `_rate_orders_indexers`: Reference to the rate orders indexers.
    /// - `_clock`: Reference to the clock.
    /// - `_ctx`: Reference to the transaction context.
    #[allow(lint(public_entry))]
    public entry fun create_rate_orders_indexer<PayCoin, TargetCoin>(
        _config: &GlobalConfig,
        _rate_orders_indexers: &mut RateOrdersIndexers,
        _clock: &Clock,
        _ctx: &mut TxContext,
    ) {
        abort 0
    }

    /// Places a new limit order.
    /// Parameters:
    /// - `_config`: Reference to the global configuration.
    /// - `_rate_orders_indexer`: Reference to the rate orders indexer.
    /// - `_user_orders_indexer`: Reference to the user orders indexer.
    /// - `_pay_coin`: Reference to the pay coin.
    /// - `_rate`: The rate at which the order is placed. rate = (pay amount * 10 ** 18) / target amount
    /// - `_expire_ts`: The expiration timestamp of the order.
    /// - `_clock`: Reference to the clock.
    /// - `_ctx`: Reference to the transaction context.
    #[allow(lint(public_entry))]
    public entry fun place_limit_order<PayCoin, TargetCoin>(
        _config: &GlobalConfig,
        _rate_orders_indexer: &mut RateOrdersIndexer<PayCoin, TargetCoin>,
        _user_orders_indexer: &mut UserOrdersIndexer,
        _pay_coin: Coin<PayCoin>,
        _rate: u128,
        _expire_ts: u64,
        _clock: &Clock,
        _ctx: &mut TxContext,
    ) {
        abort 0
    }

    /// Creates a new rate orders indexer and places a limit order.
    /// Parameters:
    /// - `_config`: Reference to the global configuration.
    /// - `_rate_orders_indexers`: Reference to the rate orders indexers.
    /// - `_user_orders_indexer`: Reference to the user orders indexer.
    /// - `_pay_coin`: Reference to the pay coin.
    /// - `_rate`: The rate at which the order is placed. rate = (pay amount * 10 ** 18) / target amount
    /// - `_expire_ts`: The expiration timestamp of the order.
    /// - `_clock`: Reference to the clock.
    /// - `_ctx`: Reference to the transaction context.
    #[allow(lint(public_entry))]
    public entry fun create_indexer_and_place_limit_order<PayCoin, TargetCoin>(
        _config: &GlobalConfig,
        _rate_orders_indexers: &mut RateOrdersIndexers,
        _user_orders_indexer: &mut UserOrdersIndexer,
        _pay_coin: Coin<PayCoin>,
        _rate: u128,
        _expire_ts: u64,
        _clock: &Clock,
        _ctx: &mut TxContext,
    ) {
        abort 0
    }

    /// Flash loan pay coin from one limit order.
    /// Parameters:
    /// - `_config`: Reference to the global configuration.
    /// - `_limit_order`: Reference to the limit order.
    /// - `_amount`: The amount of the flash loan.
    /// - `_clock`: Reference to the clock.
    /// - `_ctx`: Reference to the transaction context.
    /// Returns:
    /// - A tuple containing the pay coin and the flash loan receipt.
    public fun flash_loan<PayCoin, TargetCoin>(
        _config: &GlobalConfig,
        _limit_order: &mut LimitOrder<PayCoin, TargetCoin>,
        _amount: u64,
        _clock: &Clock,
        _ctx: &mut TxContext,
    ): (Coin<PayCoin>, FlashLoanReceipt<TargetCoin>) {
        abort 0
    }

    /// Repay flash loan.
    /// Parameters:
    /// - `_config`: Reference to the global configuration.
    /// - `_coin`: Reference to the target coin. The coin amount is the same as the one returned by the flash loan.
    /// - `_limit_order`: Reference to the limit order.
    /// - `_receipt`: The flash loan receipt.
    /// - `_ctx`: Reference to the transaction context.
    public fun repay_flash_loan<PayCoin, TargetCoin>(
        _config: &GlobalConfig,
        _coin: &mut Coin<TargetCoin>,
        _limit_order: &mut LimitOrder<PayCoin, TargetCoin>,
        _receipt: FlashLoanReceipt<TargetCoin>,
        _ctx: &mut TxContext
    ) {
        abort 0
    }

    /// Claim target coin.
    /// Parameters:
    /// - `_config`: Reference to the global configuration.
    /// - `_limit_order`: Reference to the limit order.
    /// - `_ctx`: Reference to the transaction context.
    public fun claim_target_coin<PayCoin, TargetCoin>(
        _config: &GlobalConfig,
        _limit_order: &mut LimitOrder<PayCoin, TargetCoin>,
        _ctx: &mut TxContext,
    ) {
        abort 0
    }

    /// Cancel one order by the owner.
    /// Parameters:
    /// - `_config`: Reference to the global configuration.
    /// - `_rate_orders_indexer`: Reference to the rate orders indexer.
    /// - `_limit_order`: Reference to the limit order.
    /// - `_clock`: Reference to the clock.
    /// - `_ctx`: Reference to the transaction context.
    public fun cancel_order_by_owner<PayCoin, TargetCoin>(
        _config: &GlobalConfig,
        _rate_orders_indexer: &mut RateOrdersIndexer<PayCoin, TargetCoin>,
        _limit_order: &mut LimitOrder<PayCoin, TargetCoin>,
        _clock: &Clock,
        _ctx: &mut TxContext,
    ) {
        abort 0
    }

    /// Get the orders indexer by the owner.
    /// Parameters:
    /// - `_owner`: The owner address.
    /// - `_user_orders_indexer`: Reference to the user orders indexer.
    #[allow(lint(public_entry))]
    public entry fun get_orders_indexer_by_owner(
        _owner: address,
        _user_orders_indexer: &UserOrdersIndexer
    ) {
        abort 0
    }

    /// Helper function to get the orders indexer by the rate. This method will emit the QueryRateIndexerEvent event.
    /// Parameters:
    /// - `_rate`: The rate at which the order is placed.
    /// - `_rate_orders_indexer`: Reference to the rate orders indexer.
    #[allow(lint(public_entry))]
    public entry fun get_orders_indexer_by_rate<PayCoin, TargetCoin>(
        _rate: u128,
        _rate_orders_indexer: &RateOrdersIndexer<PayCoin, TargetCoin>
    ) {
        abort 0
    }
}
