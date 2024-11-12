module stable_farming::router {
    use sui::clock::Clock;
    use sui::tx_context::{Self, TxContext};
    use sui::coin;
    use sui::coin::Coin;
    use sui::object::ID;
    use sui::transfer;
    use std::vector;
    use sui::pay;

    use cetus_clmm::position::{Position as CLMMPosition};
    use cetus_clmm::pool::{Pool as CLMMPool};
    use cetus_clmm::config::{GlobalConfig as CLMMGlobalConfig};
    use cetus_clmm::rewarder::RewarderGlobalVault;
    use integer_mate::i32;

    use stable_farming::rewarder::{Self, RewarderManager};
    use stable_farming::pool::{Self, Pool, WrappedPositionNFT};
    use stable_farming::config::{Self, AdminCap, GlobalConfig, OperatorCap};

    public entry fun set_roles(_cap: &AdminCap, _config: &mut GlobalConfig, _member: address, _roles: u128) {
        abort 0
    }

    public entry fun add_role(_cap: &AdminCap, _config: &mut GlobalConfig, _member: address, _role: u8) {
        abort 0
    }

    public entry fun remove_role(_cap: &AdminCap, _config: &mut GlobalConfig, _member: address, _role: u8) {
        abort 0
    }

    public entry fun add_operator(
        _cap: &AdminCap,
        _config: &mut GlobalConfig,
        _roles: u128,
        _recipient: address,
        _ctx: &mut TxContext
    ) {
        abort 0
    }

    #[lint_allow(self_transfer)]
    public entry fun deposit_rewarder<RewardCoin>(
        _config: &GlobalConfig,
        _manager: &mut RewarderManager,
        _coins: vector<Coin<RewardCoin>>,
        _amount: u64,
        _ctx: &mut TxContext
    ) {
        abort 0
    }

    #[lint_allow(self_transfer)]
    public entry fun emergent_withdraw<RewardCoin>(
        _cap: &AdminCap,
        _config: &GlobalConfig,
        _manager: &mut RewarderManager,
        _amount: u64,
        _ctx: &mut TxContext,
    ) {
        abort 0
    }

    public entry fun create_rewarder<RewardCoin>(
        _cap: &OperatorCap,
        _config: &GlobalConfig,
        _manager: &mut RewarderManager,
        _emission_per_second: u128,
        _clock: &Clock,
        _ctx: &mut TxContext
    ) {
        abort 0
    }

    public entry fun update_rewarder<RewardCoin>(
        _cap: &OperatorCap,
        _config: &GlobalConfig,
        _manager: &mut RewarderManager,
        _emission_per_second: u128,
        _clock: &Clock,
    ) {
        abort 0
    }

    public entry fun create_pool<CoinA, CoinB>(
        _cap: &OperatorCap,
        _global_config: &GlobalConfig,
        _rewarder_manager: &mut RewarderManager,
        _clmm_pool: &CLMMPool<CoinA, CoinB>,
        _effective_tick_lower: u32,
        _effective_tick_upper: u32,
        _sqrt_price: u128,
        _ctx: &mut TxContext
    ) {
        abort 0
    }

    public entry fun update_effective_tick_range<CoinA, CoinB>(
        _cap: &OperatorCap,
        _global_config: &GlobalConfig,
        _rewarder_manager: &mut RewarderManager,
        _pool: &mut Pool,
        _clmm_pool: &CLMMPool<CoinA, CoinB>,
        _effective_tick_lower: u32,
        _effective_tick_upper: u32,
        _sqrt_price: u128,
        _start: vector<ID>,
        _limit: u64,
        _clk: &Clock
    ) {
        abort 0
    }

    public entry fun add_rewarder<RewarderCoin>(
        _cap: &OperatorCap,
        _global_config: &GlobalConfig,
        _rewarder_manager: &mut RewarderManager,
        _pool: &mut Pool,
        _allocate_point: u64,
        _clk: &Clock,
    ) {
        abort 0
    }

    public entry fun update_pool_allocate_point<RewardCoin>(
        _cap: &OperatorCap,
        _global_config: &GlobalConfig,
        _rewarder_manager: &mut RewarderManager,
        _pool: &Pool,
        _allocate_point: u64,
        _clock: &Clock,
    ) {
        abort 0
    }

    #[lint_allow(self_transfer)]
    public entry fun deposit(
        _global_config: &GlobalConfig,
        _rewarder_manager: &mut RewarderManager,
        _pool: &mut Pool,
        _clmm_position: CLMMPosition,
        _clk: &Clock,
        _ctx: &mut TxContext
    ) {
        abort 0
    }

    #[lint_allow(self_transfer)]
    public entry fun withdraw(
        _global_config: &GlobalConfig,
        _rewarder_manager: &mut RewarderManager,
        _pool: &mut Pool,
        _wrapped_position: WrappedPositionNFT,
        _clk: &Clock,
        _ctx: &TxContext
    ) {
        abort 0
    }

    #[lint_allow(self_transfer)]
    public entry fun harvest<RewardCoin>(
        _global_config: &GlobalConfig,
        _rewarder_manager: &mut RewarderManager,
        _pool: &mut Pool,
        _wrapped_position: &WrappedPositionNFT,
        _clk: &Clock,
        _ctx: &mut TxContext
    ) {
        abort 0
    }

    public fun accumulated_position_rewards(
        _global_config: &GlobalConfig,
        _rewarder_manager: &mut RewarderManager,
        _pool: &mut Pool,
        _wrapped_position_id: ID,
        _clk: &Clock,
    ) {
        abort 0
    }

    public entry fun add_liquidity<CoinA, CoinB>(
        _global_config: &GlobalConfig,
        _clmm_global_config: &CLMMGlobalConfig,
        _rewarder_manager: &mut RewarderManager,
        _pool: &mut Pool,
        _clmm_pool: &mut CLMMPool<CoinA, CoinB>,
        _wrapped_position: &mut WrappedPositionNFT,
        _coin_a: Coin<CoinA>,
        _coin_b: Coin<CoinB>,
        _amount_limit_a: u64,
        _amount_limit_b: u64,
        _delta_liquidity: u128,
        _clk: &Clock,
        _ctx: &mut TxContext,
    ) {
        abort 0
    }

    public entry fun add_liquidity_fix_coin<CoinA, CoinB>(
        _global_config: &GlobalConfig,
        _clmm_global_config: &CLMMGlobalConfig,
        _rewarder_manager: &mut RewarderManager,
        _pool: &mut Pool,
        _clmm_pool: &mut CLMMPool<CoinA, CoinB>,
        _wrapped_position: &mut WrappedPositionNFT,
        _coin_a: Coin<CoinA>,
        _coin_b: Coin<CoinB>,
        _amount_a: u64,
        _amount_b: u64,
        _fix_amount_a: bool,
        _clk: &Clock,
        _ctx: &mut TxContext
    ) {
        abort 0
    }

    public entry fun remove_liquidity<CoinA, CoinB>(
        _global_config: &GlobalConfig,
        _clmm_global_config: &CLMMGlobalConfig,
        _rewarder_manager: &mut RewarderManager,
        _pool: &mut Pool,
        _clmm_pool: &mut CLMMPool<CoinA, CoinB>,
        _wrapped_position: &mut WrappedPositionNFT,
        _delta_liquidity: u128,
        _min_amount_a: u64,
        _min_amount_b: u64,
        _clk: &Clock,
        _ctx: &mut TxContext
    ) {
        abort 0
    }

    public entry fun collect_fee<CoinA, CoinB>(
        _global_config: &GlobalConfig,
        _clmm_global_config: &CLMMGlobalConfig,
        _clmm_pool: &mut CLMMPool<CoinA, CoinB>,
        _wrapped_position: &WrappedPositionNFT,
        _ctx: &mut TxContext
    ) {
        abort 0
    }

    public entry fun collect_clmm_reward<RewardCoin, CoinA, CoinB>(
        _global_config: &GlobalConfig,
        _clmm_global_config: &CLMMGlobalConfig,
        _clmm_pool: &mut CLMMPool<CoinA, CoinB>,
        _warped_position: &WrappedPositionNFT,
        _vault: &mut RewarderGlobalVault,
        _reward_coin: Coin<RewardCoin>,
        _clock: &Clock,
        _ctx: &mut TxContext
    ) {
        abort 0
    }

    public fun close_position<CoinA, CoinB>(
        _global_config: &GlobalConfig,
        _rewarder_manager: &mut RewarderManager,
        _pool: &mut Pool,
        _clmm_global_config: &CLMMGlobalConfig,
        _clmm_pool: &mut CLMMPool<CoinA, CoinB>,
        _wrapped_position: WrappedPositionNFT,
        _min_amount_a: u64,
        _min_amount_b: u64,
        _clk: &Clock,
        _ctx: &mut TxContext
    ) {
        abort 0
    }

    public fun send_coin<CoinType>(
        _coin: Coin<CoinType>,
        _recipient: address
    ) {
        abort 0
    }

    public fun merge_coins<CoinType>(_coins: vector<Coin<CoinType>>, _ctx: &mut TxContext): Coin<CoinType> {
        abort 0
    }
}
