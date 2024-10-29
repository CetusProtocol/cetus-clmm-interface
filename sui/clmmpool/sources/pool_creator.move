module cetus_clmm::pool_creator {
    use std::string::String;
    use sui::coin::{Coin, CoinMetadata};
    use sui::clock::Clock;
    use sui::tx_context::TxContext;


    use cetus_clmm::factory::Pools;
    use cetus_clmm::config:: GlobalConfig;
    use cetus_clmm::position::Position;
    use cetus_clmm::factory::PoolCreationCap;



    public fun create_permissioned_pool_with_full_range<CoinTypeA, CoinTypeB>(
        _pools: &mut Pools,
        _config: &GlobalConfig,
        _cap: &PoolCreationCap,
        _tick_spacing: u32,
        _initialize_price: u128,
        _url: String,
        _coin_a: Coin<CoinTypeA>,
        _coin_b: Coin<CoinTypeB>,
        _metadata_a: &CoinMetadata<CoinTypeA>,
        _metadata_b: &CoinMetadata<CoinTypeB>,
        _amount_a: u64,
        _amount_b: u64,
        _fix_amount_a: bool,
        _clock: &Clock,
        _ctx: &mut TxContext
    ): Position {
        abort 0
    }

    public fun create_pool_with_full_range<CoinTypeA, CoinTypeB>(
        _pools: &mut Pools,
        _config: &GlobalConfig,
        _tick_spacing: u32,
        _initialize_price: u128,
        _url: String,
        _coin_a: Coin<CoinTypeA>,
        _coin_b: Coin<CoinTypeB>,
        _metadata_a: &CoinMetadata<CoinTypeA>,
        _metadata_b: &CoinMetadata<CoinTypeB>,
        _amount_a: u64,
        _amount_b: u64,
        _fix_amount_a: bool,
        _clock: &Clock,
        _ctx: &mut TxContext
    ): Position {
        abort 0
    }

    public fun create_and_fund_pool_by_admin<CoinTypeA, CoinTypeB>(
        _pools: &mut Pools,
        _config: &GlobalConfig,
        _tick_spacing: u32,
        _initialize_price: u128,
        _url: String,
        _tick_lower_idx: u32,
        _tick_upper_idx: u32,
        _coin_a: Coin<CoinTypeA>,
        _coin_b: Coin<CoinTypeB>,
        _metadata_a: &CoinMetadata<CoinTypeA>,
        _metadata_b: &CoinMetadata<CoinTypeB>,
        _amount_a: u64,
        _amount_b: u64,
        _fix_amount_a: bool,
        _clock: &Clock,
        _ctx: &mut TxContext
    ): Position {
        abort 0
    }

    public fun full_range_tick_range(_tick_spacing: u32): (u32, u32) {
        abort 0
    }
}