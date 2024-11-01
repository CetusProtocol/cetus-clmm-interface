#[allow(unused_variable, unused_type_parameter, unused_field, unused_const, unused_use)]
module cetus_dca::order {
    use std::bcs;
    use std::string::{Self, String};
    use std::type_name::{Self, TypeName};
    use sui::ed25519;
    use sui::balance::{Self, Balance};
    use sui::clock::Clock;
    use sui::coin;
    use sui::coin::Coin;
    use sui::event::emit;
    use sui::table::{Self, Table};
    use sui::transfer::{share_object, public_transfer};
    use sui::hash;
    use sui::hex;
    use sui::vec_set;
    use sui::address;
    use cetus_dca::config::{GlobalConfig, receive_fee, ProtocolFeeVault};

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

    public struct OrderIndexer has key, store {
        id: UID,
        open_orders: Table<ID, bool>,
        user_orders: Table<address, Table<ID, bool>>,
    }

    public struct MakeDealReceipt {
        order_id: ID,
        in_amount: u64,
        promise_out_amount: u64,
        fee_amount: u64,
    }

    // === Events ===
    public struct InitEvent has copy, drop {
        indexer_id: ID
    }

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

    public struct WithdrawEvent has copy, drop {
        order_id: ID,
        user: address,
        out_coin: TypeName,
        out_withdrawn: u64,
        withdrawn_at: u64
    }

    public struct CancelOrderEvent has copy, drop {
        order_id: ID,
        user: address,
        in_coin: TypeName,
        out_coin: TypeName,
        in_withdrawn: u64,
        out_withdrawn: u64,
        closed_at: u64
    }

    public struct CloseOrderEvent has copy, drop {
        order_id: ID,
        user: address,
        out_coin: TypeName,
        out_withdrawn: u64,
        closed_at: u64
    }

    // === functions ===

    public fun open_order<InCoin, OutCoin>(
        config: &GlobalConfig,
        in_coin: Coin<InCoin>,
        cycle_frequency: u64,
        cycle_count: u64,
        min_out_amount_per_cycle: u64,
        max_out_amount_per_cycle: u64,
        in_amount_limit_per_cycle: u64,
        fee_rate: u64,
        timestamp: u64,
        signature: String,
        clk: &Clock,
        indexer: &mut OrderIndexer,
        ctx: &mut TxContext
    ) {
        abort 0
    }

    public fun withdraw<InCoin, OutCoin>(
        config: &GlobalConfig,
        order: &mut Order<InCoin, OutCoin>,
        clk: &Clock,
        ctx: &mut TxContext
    ): Coin<OutCoin> {
        abort 0
    }

    public fun cancle_order<InCoin, OutCoin>(
        config: &GlobalConfig,
        order: &mut Order<InCoin, OutCoin>,
        indexer: &mut OrderIndexer,
        clk: &Clock,
        ctx: &mut TxContext
    ): (Coin<InCoin>, Coin<OutCoin>) {
        abort 0
    }
}
