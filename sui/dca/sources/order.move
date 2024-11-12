// Copyright (c) Cetus Technology Limited

#[allow(unused_type_parameter, unused_field, unused_const)]
module cetus_dca::order {
    use std::string::String;
    use std::type_name::TypeName;
    use sui::balance::Balance;
    use sui::clock::Clock;
    use sui::coin::Coin;
    use sui::table::Table;
    use cetus_dca::config::GlobalConfig;

    // === Constans ===
    const ED25519: u8 = 0;
    const FEE_RATE_DENOMINATOR: u128 = 1000000;

    const CHECK_ORACLE: u8 = 0;
    const CHECK_KEEPER: u8 = 1;

    const ORDER_STATUS_PENDING: u64 = 0;
    const ORDER_STATUS_FINISHED: u64 = 1;
    const ORDER_STATUS_CANCLED: u64 = 2;

    // === Errors ===
    const ECycleCountLimit: u64 = 0;
    const ECycleFrequencyLimit: u64 = 1;
    const EOrderCycleAmountLeftIsZero: u64 = 2;
    const ENotYetTimeForMakeDeal: u64 = 3;
    const EOutAmountLtMinLimit: u64 = 4;
    const EOutAmountGtMaxLimit: u64 = 5;
    const EOutAmountLtPromise: u64 = 6;
    const EPerCycleMinInAmountLimit: u64 = 7;
    const EInvalidOrderId: u64 = 8;
    const EIsNotOrderOwner: u64 = 9;
    const ESchemeNotSupport: u64 = 10;
    const EOracleSignatureExpired: u64 = 11;
    const EInvalidOracleSignature: u64 = 12;
    const EOrderNotPending: u64 = 13;
    const EKeeperValidate: u64 = 14;
    const ETradePairUnSupported: u64 = 15;
    const EOutAmountLimitRange: u64 = 16;

    // === Structs ===

    /// DCA Order struct
    public struct Order<phantom InCoin, phantom OutCoin> has key, store {
        id: UID,
        user: address,
        in_deposited: u64,
        in_withdrawn: u64,
        out_withdrawn: u64,
        in_balance: Balance<InCoin>,
        out_balance: Balance<OutCoin>,
        cycle_frequency: u64,
        in_amount_per_cycle: u64,
        amount_left_next_cycle: u64,
        next_cycle_at: u64,
        min_out_amount_per_cycle: u64,
        max_out_amount_per_cycle: u64,
        fee_rate: u64,
        status: u64,
        created_at: u64
    }

    /// Order Indexer struct, used to store the open orders and user orders
    public struct OrderIndexer has key, store {
        id: UID,
        open_orders: Table<ID, bool>,
        user_orders: Table<address, Table<ID, bool>>,
    }

    /// Make Deal Receipt struct, used to store the make deal receipt
    public struct MakeDealReceipt {
        order_id: ID,
        in_amount: u64,
        promise_out_amount: u64,
        fee_amount: u64,
    }

    // === Events ===

    /// Emitted when a new order is opened.
    public struct OpenOrderEvent has copy, drop {
        order_id: ID,
        user: address,
        in_coin: TypeName,
        out_coin: TypeName,
        in_deposited: u64,
        cycle_count: u64,
        cycle_frequency: u64,
        in_amount_per_cycle: u64,
        in_amount_limit_per_cycle: u64,
        min_out_amount_per_cycle: u64,
        max_out_amount_per_cycle: u64,
        fee_rate: u64,
        created_at: u64
    }

    /// Emitted when a deal is made.
    public struct MakeDealEvent has copy, drop {
        order_id: ID,
        user: address,
        in_coin: TypeName,
        out_coin: TypeName,
        in_amount: u64,
        out_amount: u64,
        promise_out_amount: u64,
        after_in_balance: u64,
        after_out_balance: u64,
        fee_amount: u64,
        execution_at: u64
    }

    /// Emitted when a deal is made.
    public struct WithdrawEvent has copy, drop {
        order_id: ID,
        user: address,
        out_coin: TypeName,
        out_withdrawn: u64,
        withdrawn_at: u64
    }

    /// Emitted when an order is cancelled.
    public struct CancelOrderEvent has copy, drop {
        order_id: ID,
        user: address,
        in_coin: TypeName,
        out_coin: TypeName,
        in_withdrawn: u64,
        out_withdrawn: u64,
        closed_at: u64
    }

    /// Emitted when an order is closed.
    public struct CloseOrderEvent has copy, drop {
        order_id: ID,
        user: address,
        out_coin: TypeName,
        out_withdrawn: u64,
        closed_at: u64
    }

    // === functions ===

    /// Open a new order
    /// Parameters:
    /// - `_config`: GlobalConfig struct
    /// - `_in_coin`: Input coin
    /// - `_cycle_frequency`: Frequency of order execution (in seconds)
    /// - `_cycle_count`: Total cycle count of order execution.
    /// - `_min_out_amount_per_cycle`: Minimum amount of out_coin obtained per transaction.
    /// - `_max_out_amount_per_cycle`: Maximum amount of out_coin obtained per transaction.
    /// - `_in_amount_limit_per_cycle`: Amount of in_coin per transaction (in_deposited divided by in_amount_per_cycle gives the number of cycles)
    /// - `_fee_rate`: Transaction fee rate (denominator is 1,000,000)
    /// - `_timestamp`: Current timestamp when order created.
    /// - `_signature`: Create by cetus quote service, it will check the `in_amount_per_cycle`,`fee_rate`, `timestamp`.
    /// - `_clk`: Clock
    /// - `_indexer`: OrderIndexer struct
    /// - `_ctx`: Transaction context
    public fun open_order<InCoin, OutCoin>(
        _config: &GlobalConfig,
        _in_coin: Coin<InCoin>,
        _cycle_frequency: u64,
        _cycle_count: u64,
        _min_out_amount_per_cycle: u64,
        _max_out_amount_per_cycle: u64,
        _in_amount_limit_per_cycle: u64,
        _fee_rate: u64,
        _timestamp: u64,
        _signature: String,
        _clk: &Clock,
        _indexer: &mut OrderIndexer,
        _ctx: &mut TxContext
    ) {
        abort 0
    }

    /// Withdraw out_coin from the order
    /// Parameters:
    /// - `_config`: GlobalConfig struct
    /// - `_order`: Order struct
    /// - `_clk`: Clock
    /// - `_ctx`: Transaction context
    public fun withdraw<InCoin, OutCoin>(
        _config: &GlobalConfig,
        _order: &mut Order<InCoin, OutCoin>,
        _clk: &Clock,
        _ctx: &mut TxContext
    ): Coin<OutCoin> {
        abort 0
    }

    /// Cancle the order
    /// Parameters:
    /// - `_config`: GlobalConfig struct
    /// - `_order`: Order struct
    /// - `_indexer`: OrderIndexer struct
    /// - `_clk`: Clock
    /// - `_ctx`: Transaction context
    public fun cancle_order<InCoin, OutCoin>(
        _config: &GlobalConfig,
        _order: &mut Order<InCoin, OutCoin>,
        _indexer: &mut OrderIndexer,
        _clk: &Clock,
        _ctx: &mut TxContext
    ): (Coin<InCoin>, Coin<OutCoin>) {
        abort 0
    }
}
