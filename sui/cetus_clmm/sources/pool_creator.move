module cetus_clmm::pool_creator {
    use std::string::String;
    use sui::coin::{Coin, CoinMetadata};
    use sui::clock::Clock;
    use sui::tx_context::TxContext;

    use cetus_clmm::factory::Pools;
    use cetus_clmm::config:: GlobalConfig;
    use cetus_clmm::position::Position;
    use cetus_clmm::factory::PoolCreationCap;

    // Deprecated
    public fun create_pool_v2_by_creation_cap<CoinTypeA, CoinTypeB>(
        _config: &GlobalConfig,
        _pools: &mut Pools,
        _cap: &PoolCreationCap,
        _tick_spacing: u32,
        _initialize_price: u128,
        _url: String,
        _coin_a: Coin<CoinTypeA>,
        _coin_b: Coin<CoinTypeB>,
        _metadata_a: &CoinMetadata<CoinTypeA>,
        _metadata_b: &CoinMetadata<CoinTypeB>,
        _fix_amount_a: bool,
        _clock: &Clock,
        _ctx: &mut TxContext
    ): (Position, Coin<CoinTypeA>, Coin<CoinTypeB>) {
        abort 0
    }

    public fun create_pool_v2_with_creation_cap<CoinTypeA, CoinTypeB>(
        _config: &GlobalConfig,
        _pools: &mut Pools,
        _cap: &PoolCreationCap,
        _tick_spacing: u32,
        _initialize_price: u128,
        _url: String,
        _tick_lower_idx: u32,
        _tick_upper_idx: u32,
        _coin_a: Coin<CoinTypeA>,
        _coin_b: Coin<CoinTypeB>,
        _metadata_a: &CoinMetadata<CoinTypeA>,
        _metadata_b: &CoinMetadata<CoinTypeB>,
        _fix_amount_a: bool,
        _clock: &Clock,
        _ctx: &mut TxContext
    ): (Position, Coin<CoinTypeA>, Coin<CoinTypeB>){
        abort 0
    }

    public fun create_pool_v2<CoinTypeA, CoinTypeB>(
        _config: &GlobalConfig,
        _pools: &mut Pools,
        _tick_spacing: u32,
        _initialize_price: u128,
        _url: String,
        _tick_lower_idx: u32,
        _tick_upper_idx: u32,
        _coin_a: Coin<CoinTypeA>,
        _coin_b: Coin<CoinTypeB>,
        _metadata_a: &CoinMetadata<CoinTypeA>,
        _metadata_b: &CoinMetadata<CoinTypeB>,
        _fix_amount_a: bool,
        _clock: &Clock,
        _ctx: &mut TxContext
    ):  (Position, Coin<CoinTypeA>, Coin<CoinTypeB>) {
        abort 0
    }

    public fun full_range_tick_range(_tick_spacing: u32): (u32, u32) {
        abort 0
    }
}