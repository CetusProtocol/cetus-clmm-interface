module cetus_clmm::factory {
    use std::string::String;
    use std::type_name::TypeName;
    use sui::clock::Clock;
    use sui::tx_context::TxContext;
    use sui::object::{ID, UID};
    use sui::coin::{Coin};

    use move_stl::linked_table::{LinkedTable};


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

    struct Pools has key, store {
        id: UID,
        list: LinkedTable<ID, PoolSimpleInfo>,
        index: u64,
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

    public fun new_pool_key<CoinTypeA, CoinTypeB>(_tick_spacing: u32): ID {
        abort 0
    }
}