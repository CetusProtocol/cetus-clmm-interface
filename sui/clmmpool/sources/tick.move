// Copyright (c) Cetus Technology Limited

/// The `tick` module is a module that is designed to facilitate the management of `tick` owned by `Pool`.
/// All `tick` related operations of `Pool` are handled by this module.
module cetus_clmm::tick {
    use std::option::Option;

    use integer_mate::i32::I32;
    use integer_mate::i128::I128;

    use move_stl::skip_list::SkipList;
    use move_stl::option_u64::OptionU64;

    #[allow(unused_field)]
    /// Manager ticks of a pool, ticks is organized into SkipList.
    struct TickManager has store {
        tick_spacing: u32,
        ticks: SkipList<Tick>
    }

    #[allow(unused_field)]
    /// Tick infos.
    struct Tick has copy, drop, store {
        index: I32,
        sqrt_price: u128,
        liquidity_net: I128,
        liquidity_gross: u128,
        fee_growth_outside_a: u128,
        fee_growth_outside_b: u128,
        points_growth_outside: u128,
        rewards_growth_outside: vector<u128>,
    }

    /// return the next tick index for swap.
    public fun first_score_for_swap(
        _manager: &TickManager,
        _current_tick_idx: I32,
        _a2b: bool,
    ): OptionU64 {
        abort 0
    }

    /// Borrow Tick by score and return the next tick score for swap.
    public fun borrow_tick_for_swap(_manager: &TickManager, _score: u64, _a2b: bool): (&Tick, OptionU64) {
        abort 0
    }

    /// Get tick_spacing.
    public fun tick_spacing(_manager: &TickManager): u32 {
        abort 0
    }

    /// Get tick index
    public fun index(_tick: &Tick): I32 {
        abort 0
    }

    /// Get tick sqrt_price
    public fun sqrt_price(_tick: &Tick): u128 {
        abort 0
    }

    /// Get tick liquidity_net
    public fun liquidity_net(_tick: &Tick): I128 {
        abort 0
    }

    /// Get tick liquidity_gross
    public fun liquidity_gross(_tick: &Tick): u128 {
        abort 0
    }

    /// Get tick fee_growth_insides
    public fun fee_growth_outside(_tick: &Tick): (u128, u128) {
        abort 0
    }

    /// Get tick points_growth_outside
    public fun points_growth_outside(_tick: &Tick): u128 {
        abort 0
    }

    /// Get tick rewards_growth_outside
    public fun rewards_growth_outside(_tick: &Tick): &vector<u128> {
        abort 0
    }

    /// Borrow Tick by index
    public fun borrow_tick(_manager: &TickManager, _idx: I32): &Tick {
        abort 0
    }

    /// Get the tick reward_growth_outside by index.
    public fun get_reward_growth_outside(_tick: &Tick, _idx: u64): u128 {
        abort 0
    }

    /// Get the fee inside in tick range.
    public fun get_fee_in_range(
        _pool_current_tick_index: I32,
        _fee_growth_global_a: u128,
        _fee_growth_global_b: u128,
        _op_tick_lower: Option<Tick>,
        _op_tick_upper: Option<Tick>
    ): (u128, u128) {
        abort 0
    }

    /// Get the rewards inside in tick range.
    public fun get_rewards_in_range(
        _pool_current_tick_index: I32,
        _rewards_growth_globals: vector<u128>,
        _op_tick_lower: Option<Tick>,
        _op_tick_upper: Option<Tick>
    ): vector<u128> {
        abort 0
    }

    /// Get the points inside in tick range.
    public fun get_points_in_range(
        _pool_current_tick_index: I32,
        _points_growth_global: u128,
        _op_tick_lower: Option<Tick>,
        _op_tick_upper: Option<Tick>
    ): u128 {
        abort 0
    }


    /// Fetch Ticks
    /// Params
    ///     -start: start tick index
    ///     - limit: max number of ticks to fetch
    public fun fetch_ticks(
        _manager: &TickManager,
        _start: vector<u32>,
        _limit: u64
    ): vector<Tick> {
        abort 0
    }
}
