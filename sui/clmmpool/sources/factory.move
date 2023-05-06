module cetus_clmm::factory {
    use std::vector;
    use std::ascii;
    use std::bcs;
    use std::option;
    use std::string::{Self, String};
    use std::type_name::{Self, TypeName};

    use sui::hash;
    use sui::clock::Clock;
    use sui::transfer;
    use sui::event;
    use sui::tx_context::TxContext;
    use sui::object::{Self, ID, UID};
    use sui::coin::{Self, Coin};

    use move_stl::linked_table::{Self, LinkedTable};

    use cetus_clmm::tick_math;
    use cetus_clmm::config::{Self, GlobalConfig, checked_package_version};
    use cetus_clmm::pool::{Self, Pool};
    use cetus_clmm::position::Position;
    

    public fun pool_id(info: &PoolSimpleInfo): ID {
        abort 0;
    }

    public fun pool_key(info: &PoolSimpleInfo): ID {
        abort 0;
    }

    public fun coin_types(info: &PoolSimpleInfo): (TypeName, TypeName) {
        abort 0;
    }

    public fun tick_spacing(info: &PoolSimpleInfo): u32 {
        abort 0;
    }

    public fun index(pools: &Pools): u64 {
        abort 0;
    }

    public fun pool_simple_info(pools: &Pools, pool_key: ID): &PoolSimpleInfo {
        abort 0;
    }

    public fun create_pool<CoinTypeA, CoinTypeB>(
        pools: &mut Pools,
        config: &GlobalConfig,
        tick_spacing: u32,
        initialize_price: u128,
        url: String,
        clock: &Clock,
        ctx: &mut TxContext
    ) {
        abort 0;
    }

    public fun create_pool_with_liquidity<CoinTypeA, CoinTypeB>(
        pools: &mut Pools,
        config: &GlobalConfig,
        tick_spacing: u32,
        initialize_price: u128,
        url: String,
        tick_lower_idx: u32,
        tick_upper_idx: u32,
        coin_a: Coin<CoinTypeA>,
        coin_b: Coin<CoinTypeB>,
        amount_a: u64,
        amount_b: u64,
        fix_amount_a: bool,
        clock: &Clock,
        ctx: &mut TxContext
    ): (Position, Coin<CoinTypeA>, Coin<CoinTypeB>) {
        abort 0;
    }

    public fun fetch_pools(
        pools: &Pools,
        start: vector<ID>,
        limit: u64
    ): vector<PoolSimpleInfo> {
        abort 0;
    }

    public fun new_pool_key<CoinTypeA, CoinTypeB>(tick_spacing: u32): ID {
        abort 0;
    }
}