#[allow(unused_type_parameter, unused_field, unused_function, unused_use, unused_const, unused_variable)]
module farming::pool {
    use std::option::{Self, Option};
    use std::type_name::{Self, TypeName};
    use std::string::{String, utf8};

    use sui::balance::{Self, Balance};
    use sui::vec_map;
    use sui::object::{Self, UID, ID};
    use sui::linked_table::{Self, LinkedTable};
    use sui::coin::{Self, Coin};
    use sui::tx_context::{TxContext, sender};
    use sui::clock::Clock;

    use integer_mate::i32::{Self, I32};
    use integer_mate::full_math_u128;

    use cetusclmm::clmm_math::get_amount_by_liquidity;
    use cetusclmm::position::{Self as clmm_position, Position as CLMMPosition};
    use cetusclmm::pool::{Self as clmm_pool, Pool as CLMMPool};
    use cetusclmm::config::{GlobalConfig as CLMMGlobalConfig};
    use cetusclmm::rewarder::RewarderGlobalVault;
    use cetusclmm::tick_math;
    use sui::event::emit;

    use farming::rewarder::{Self, RewarderManager};
    use farming::config::{GlobalConfig, OperatorCap, checked_package_version, check_pool_manager_role };

    const REWARD_PRECISION: u128 = 1000000000000;

    const EInvalidClmmPoolId: u64 = 1;
    const EPoolPositionNotMatch: u64 = 2;
    const EPoolCLmmPoolNotMatch: u64 = 3;
    const ERewarderNotHarvested: u64 = 4;
    const EEffectiveRangeError: u64 = 5;
    const ERewarderNotExists: u64 = 6;
    const ERewarderAlreadyExists: u64 = 7;
    const EPoolHasNoRewarder: u64 = 8;
    const EStartError: u64 = 9;
    const EInvalidTickRange: u64 = 10;
    const EInvalidSqrtPrice: u64 = 11;
    const EAmountInAboveMaxLimit: u64 = 12;
    const EAmountOutBelowMinLimit: u64 = 15;

    struct POOL has drop {}

    struct WrappedPositionNFT has key, store {
        id: UID,
        _pool_id: ID,
        _clmm_postion: CLMMPosition,
        _url: String
    }

    struct PositionRewardInfo has copy, store, drop {
        _reward: u128,
        _reward_debt: u128,
        _reward_harvested: u64,
    }

    struct WrappedPositionInfo has store {
        _id: ID,
        _pool_id: ID,
        _clmm_pool_id: ID,
        _clmm_position_id: ID,
        _tick_lower: I32,
        _tick_upper: I32,
        _liquidity: u128,
        _effective_tick_lower: I32,
        _effective_tick_upper: I32,
        _sqrt_price: u128,
        _share: u128,
        _rewards: vec_map::VecMap<TypeName, PositionRewardInfo>
    }

    struct Pool has key, store {
        id: UID,
        _clmm_pool_id: ID,
        _effective_tick_lower: I32,
        _effective_tick_upper: I32,
        _sqrt_price: u128,
        _total_share: u128,
        _rewarders: vector<TypeName>,
        _positions: LinkedTable<ID, WrappedPositionInfo>
    }

    struct CreatePoolEvent has drop, copy {
        _pool_id: ID,
        _clmm_pool_id: ID,
        _sqrt_price: u128,
        _effective_tick_lower: I32,
        _effective_tick_upper: I32,
    }

    struct UpdateEffectiveTickRangeEvent has copy, drop {
        _pool_id: ID,
        _clmm_pool_id: ID,
        _effective_tick_lower: I32,
        _effective_tick_upper: I32,
        _sqrt_price: u128,
        _start: vector<ID>,
        _end: Option<ID>,
        _limit: u64,
    }

    struct AddRewardEvent has drop, copy {
        _pool_id: ID,
        _clmm_pool_id: ID,
        _rewarder: TypeName,
        _allocate_point: u64
    }

    struct UpdatePoolAllocatePointEvent has drop, copy {
        _pool_id: ID,
        _clmm_pool_id: ID,
        _old_allocate_point: u64,
        _new_allocate_point: u64
    }

    struct DepositEvent has drop, copy {
        _pool_id: ID,
        _wrapped_position_id: ID,
        _clmm_pool_id: ID,
        _clmm_position_id: ID,
        _effective_tick_lower: I32,
        _effective_tick_upper: I32,
        _sqrt_price: u128,
        _liquidity: u128,
        _share: u128,
        _pool_total_share: u128
    }

    struct WithdrawEvent has drop, copy {
        _pool_id: ID,
        _wrapped_position_id: ID,
        _clmm_pool_id: ID,
        _clmm_position_id: ID,
        _share: u128
    }

    struct HarvestEvent has drop, copy {
        _pool_id: ID,
        _wrapped_position_id: ID,
        _clmm_pool_id: ID,
        _clmm_position_id: ID,
        _rewarder_type: TypeName,
        _amount: u64
    }

    struct AccumulatedPositionRewardsEvent has drop, copy {
        _pool_id: ID,
        _wrapped_position_id: ID,
        _clmm_position_id: ID,
        _rewards: vec_map::VecMap<TypeName, u64>
    }

    struct AddLiquidityEvent has drop, copy {
        _pool_id: ID,
        _wrapped_position_id: ID,
        _clmm_poo_id: ID,
        _clmm_position_id: ID,
        _effective_tick_lower: I32,
        _effective_tick_upper: I32,
        _sqrt_price: u128,
        _old_liquidity: u128,
        _new_liquidity: u128,
        _old_share: u128,
        _new_share: u128,
    }

    struct AddLiquidityFixCoinEvent has drop, copy {
        _pool_id: ID,
        _wrapped_position_id: ID,
        _clmm_poo_id: ID,
        _clmm_position_id: ID,
        _effective_tick_lower: I32,
        _effective_tick_upper: I32,
        _sqrt_price: u128,
        _old_liquidity: u128,
        _new_liquidity: u128,
        _old_share: u128,
        _new_share: u128,
    }

    struct RemoveLiquidityEvent has drop, copy {
        _pool_id: ID,
        _wrapped_position_id: ID,
        _clmm_poo_id: ID,
        _clmm_position_id: ID,
        _effective_tick_lower: I32,
        _effective_tick_upper: I32,
        _sqrt_price: u128,
        _old_liquidity: u128,
        _new_liquidity: u128,
        _old_share: u128,
        _new_share: u128,
    }

    #[allow(unused_function)]
    fun init(_otw: POOL, _ctx: &mut TxContext) {
        abort 0
    }

    public fun create_pool<CoinA, CoinB>(
        _cap: &OperatorCap,
        _global_config: &GlobalConfig,
        _rewarder_manager: &mut RewarderManager,
        _clmm_pool: &CLMMPool<CoinA, CoinB>,
        _effective_tick_lower: I32,
        _effective_tick_upper: I32,
        _sqrt_price: u128,
        _ctx: &mut TxContext
    ){
        abort 1
    }

    public fun add_rewarder<RewarderCoin>(
        _cap: &OperatorCap,
        _global_config: &GlobalConfig,
        _rewarder_manager: &mut RewarderManager,
        _pool: &mut Pool,
        _allocate_point: u64,
        _clk: &Clock,
    ) {
        abort 0
    }


    public fun update_pool_allocate_point<RewardCoin>(
        _cap: &OperatorCap,
        _global_config: &GlobalConfig,
        _rewarder_manager: &mut RewarderManager,
        _pool: &Pool,
        _allocate_point: u64,
        _clock: &Clock,
    ) {
        abort 0
    }

    public fun deposit(
        _global_config: &GlobalConfig,
        _rewarder_manager: &mut RewarderManager,
        _pool: &mut Pool,
        _clmm_position: CLMMPosition,
        _clk: &Clock,
        _ctx: &mut TxContext
    ): WrappedPositionNFT{
        abort 1
    }

    public fun withdraw(
        _global_config: &GlobalConfig,
        _rewarder_manager: &mut RewarderManager,
        _pool: &mut Pool,
        _wrapped_position: WrappedPositionNFT,
        _clk: &Clock,
    ): CLMMPosition{
        abort 1
    }

    public fun calculate_position_share(
        _tick_lower: I32,
        _tick_upper: I32,
        _liquidity: u128,
        _sqrt_price: u128,
        _effective_tick_lower: I32,
        _effective_tick_upper: I32,
    ): u128 {
        abort 0
    }

    public fun check_effective_range(_effective_tick_lower: I32, _effective_tick_upper: I32, _sqrt_price: u128) {
        abort 0
    }

    public fun add_liquidity_fix_coin<CoinA, CoinB>(
        global_config: &GlobalConfig,
        clmm_global_config: &CLMMGlobalConfig,
        rewarder_manager: &mut RewarderManager,
        pool: &mut Pool,
        clmm_pool: &mut CLMMPool<CoinA, CoinB>,
        wrapped_position: &mut WrappedPositionNFT,
        coin_a: Coin<CoinA>,
        coin_b: Coin<CoinB>,
        amount_a: u64,
        amount_b: u64,
        fix_amount_a: bool,
        clk: &Clock,
        ctx: &mut TxContext
    ): (Balance<CoinA>, Balance<CoinB>){
        abort 1
    }

    public fun collect_fee<CoinA, CoinB>(
        _global_config: &GlobalConfig,
        _clmm_global_config: &CLMMGlobalConfig,
        _clmm_pool: &mut CLMMPool<CoinA, CoinB>,
        _wrapped_position: &WrappedPositionNFT,
        _recalculate: bool,
    ): (Balance<CoinA>, Balance<CoinB>) {
      abort 1
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
    ): (Balance<CoinA>, Balance<CoinB>){
        abort 1
    }

    public fun remove_liquidity<CoinA, CoinB>(
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
    ): (Balance<CoinA>, Balance<CoinB>){
        abort 1
    }

    public fun collect_clmm_reward<RewardCoin, CoinA, CoinB>(
        _global_config: &GlobalConfig,
        _clmm_global_config: &CLMMGlobalConfig,
        _clmm_pool: &mut CLMMPool<CoinA, CoinB>,
        _warped_position: &WrappedPositionNFT,
        _vault: &mut RewarderGlobalVault,
        _reward_coin: Coin<RewardCoin>,
        _recalculate: bool,
        _clock: &Clock,
        _ctx: &mut TxContext
    ): Balance<RewardCoin> {
        abort 0
    }

    public fun harvest<RewardCoin>(
        _global_config: &GlobalConfig,
        _rewarder_manager: &mut RewarderManager,
        _pool: &mut Pool,
        _wrapped_position: &WrappedPositionNFT,
        _clk: &Clock,
    ): Balance<RewardCoin> {
        abort 0
    }

    public fun borrow_clmm_position(_: &WrappedPositionNFT): &CLMMPosition {
        abort 0
    }

    public fun borrow_wrapped_position_info(pool: &Pool, id: ID): &WrappedPositionInfo {
        abort 1
    }

    public fun borrow_rewarders(info: &WrappedPositionInfo): &vec_map::VecMap<TypeName, PositionRewardInfo> {
        abort 1
    }

    public fun position_rewarder_info(
        _wrapped_position_rewarder_info: &WrappedPositionInfo,
        _rewarder_type: &TypeName
    ): PositionRewardInfo{
        abort 1
    }

    public fun borrow_position_rewarder_info(
        _wrapped_position_rewarder_info: &WrappedPositionInfo,
        _rewarder_type: &TypeName
    ): &PositionRewardInfo {
        abort 1
    }

    public fun reward_debt(_info: &PositionRewardInfo): u128 {
        abort 1
    }

    public fun reward(_info: &PositionRewardInfo): u128 {
        abort 1
    }

    public fun reward_harvested(_info: &PositionRewardInfo): u64 {
        abort 1
    }

    public fun borrow_pool_rewarders(_pool: &Pool): &vector<TypeName> {
        abort 1
    }

    public fun total_share(_pool: &Pool): u128 {
        abort 1
    }

    public fun add_liquidity<CoinA, CoinB>(
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
    ): (Balance<CoinA>, Balance<CoinB>) {
        abort 1
    }

    public fun accumulated_position_rewards(
        global_config: &GlobalConfig,
        rewarder_manager: &mut RewarderManager,
        pool: &mut Pool,
        wrapped_position_id: ID,
        clk: &Clock,
    ) {}
    
    
}
