// Copyright (c) Cetus Technology Limited

#[allow(unused_field)]
// The factory module is provided to create and manage pools.
// The `Pools` is a singleton, and the `Pools` is initialized when the contract is deployed.
// The pools are organized in a linked list, and the key is generate by hash([coin_type_a + coin_type_b]). The details can be found in `new_pool_key` function.
// When create a pool, the `CoinTypeA` and `CoinTypeB` must be different, and the `CoinTypeA` must be the bigger one(string order).
module cetus_clmm::factory {
    use std::string::String;
    use std::type_name::TypeName;

    use sui::clock::Clock;
    use sui::tx_context::TxContext;
    use sui::object::{Self, ID, UID};
    use sui::coin::{Coin};

    use move_stl::linked_table::{Self, LinkedTable};

    use cetus_clmm::config::{GlobalConfig};
    use cetus_clmm::position::Position;
    
    // === Structs ===
    
    struct PoolSimpleInfo has store, copy, drop {
        pool_id: ID,
        pool_key: ID,
        coin_type_a: TypeName,
        coin_type_b: TypeName,
        tick_spacing: u32,
    }

    
    /// hold the pool list, and the pool list is organized in a linked list.
    /// index is the max index used by pools.
    struct Pools has key, store {
        id: UID,
        list: LinkedTable<ID, PoolSimpleInfo>,
        index: u64,
    }

    // === Events ===

    
    /// Emit when init factory.
    struct InitFactoryEvent has copy, drop {
        pools_id: ID,
    }

    
    /// Emit when create pool.
    struct CreatePoolEvent has copy, drop {
        pool_id: ID,
        coin_type_a: String,
        coin_type_b: String,
        tick_spacing: u32,
    }

    public fun pool_id(_info: &PoolSimpleInfo): ID {
        abort 0
    }

    public fun pool_key(_info: &PoolSimpleInfo): ID {
        abort 0
    }

    public fun coin_types(_info: &PoolSimpleInfo): (TypeName, TypeName) {
        abort 0
    }

    public fun tick_spacing(_info: &PoolSimpleInfo): u32 {
        abort 0
    }

    public fun index(_pools: &Pools): u64 {
        abort 0
    }

    public fun pool_simple_info(_pools: &Pools, _pool_key: ID): &PoolSimpleInfo {
        abort 0
    }

    #[allow(unused_type_parameter)]
    public fun create_pool<CoinTypeA, CoinTypeB>(
        _pools: &mut Pools,
        _config: &GlobalConfig,
        _tick_spacing: u32,
        _initialize_price: u128,
        _url: String,
        _clock: &Clock,
        _ctx: &mut TxContext
    ) {
        abort 0
    }

    public fun create_pool_with_liquidity<CoinTypeA, CoinTypeB>(
        _pools: &mut Pools,
        _config: &GlobalConfig,
        _tick_spacing: u32,
        _initialize_price: u128,
        _url: String,
        _tick_lower_idx: u32,
        _tick_upper_idx: u32,
        _coin_a: Coin<CoinTypeA>,
        _coin_b: Coin<CoinTypeB>,
        _amount_a: u64,
        _amount_b: u64,
        _fix_amount_a: bool,
        _clock: &Clock,
        _ctx: &mut TxContext
    ): (Position, Coin<CoinTypeA>, Coin<CoinTypeB>) {
        abort 0
    }

    public fun fetch_pools(
        _pools: &Pools,
        _start: vector<ID>,
        _limit: u64
    ): vector<PoolSimpleInfo> {
        abort 0
    }

    #[allow(unused_type_parameter)]
    public fun new_pool_key<CoinTypeA, CoinTypeB>(_tick_spacing: u32): ID {
        abort 0
    }

    #[test_only]
    public fun new_pools_for_test(ctx: &mut TxContext): Pools {
        Pools {
            id: object::new(ctx),
            list: linked_table::new(ctx),
            index: 0
        }
    }
}