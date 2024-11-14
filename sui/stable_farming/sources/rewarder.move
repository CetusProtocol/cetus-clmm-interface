#[allow(unused_type_parameter, unused_field, unused_function, unused_const, unused_use)]
module stable_farming::rewarder {
    use std::type_name::{Self, TypeName};
    use std::option;
    use std::vector;
    use sui::vec_map;

    use sui::object::{Self, ID, UID};
    use sui::bag::{Self, Bag};
    use sui::linked_table::{Self, LinkedTable};
    use sui::transfer;
    use sui::event::{emit};
    use sui::tx_context::TxContext;
    use sui::clock::{Self, Clock};
    use sui::balance::{Self, Balance};

    use integer_mate::full_math_u128;
    use stable_farming::config::{Self, OperatorCap, GlobalConfig, checked_package_version, AdminCap};
    friend stable_farming::pool;

    const REWARD_PRECISION: u128 = 1000000000000;

    struct PoolRewarderInfo has store {
        _allocate_point: u64,
        _acc_per_share: u128,
        _last_reward_time: u64,
        _reward_released: u128,
        _reward_harvested: u64
    }

    struct Rewarder has store {
        _reward_coin: TypeName,
        _total_allocate_point: u64,
        _emission_per_second: u128,
        _last_reward_time: u64,
        _total_reward_released: u128,
        _total_reward_harvested: u64,
        _pools: LinkedTable<ID, PoolRewarderInfo>
    }

    struct RewarderManager has key, store {
        id: UID,
        _vault: Bag,
        _pool_shares: LinkedTable<ID, u128>,
        _rewarders: LinkedTable<TypeName, Rewarder>
    }

    struct InitRewarderManagerEvent has copy, drop {
        _id: ID,
    }

    struct CreateRewarderEvent has copy, drop {
        _reward_coin: TypeName,
        _emission_per_second: u128,
    }

    struct UpdateRewarderEvent has copy, drop {
        _reward_coin: TypeName,
        _emission_per_second: u128,
    }

    struct DepositEvent has copy, drop {
        _reward_type: TypeName,
        _deposit_amount: u64,
        _after_amount: u64
    }

    struct EmergentWithdrawEvent has copy, drop, store {
        _reward_type: TypeName,
        _withdraw_amount: u64,
        _after_amount: u64
    }

    #[allow(unused_function)]
    fun init(_ctx: &mut TxContext) {
        abort 0
    }

    public fun deposit_rewarder<CoinType>(
        _global_config: &GlobalConfig,
        _manager: &mut RewarderManager,
        _balance: Balance<CoinType>
    ) {
        abort 0
    }

    public fun emergent_withdraw<RewardCoin>(
        _: &AdminCap,
        _config: &GlobalConfig,
        _manager: &mut RewarderManager,
        _amount: u64
    ): Balance<RewardCoin> {
        abort 0
    }

    public fun create_rewarder<RewardCoin>(
        _cap: &OperatorCap,
        _config: &GlobalConfig,
        _manager: &mut RewarderManager,
        _emission_per_second: u128,
        _clock: &Clock,
        _ctx: &mut TxContext
    ) {
        abort 0
    }

    public(friend) fun register_pool(_manager: &mut RewarderManager, _clmm_pool_id: ID) {
        abort 0
    }

    public(friend) fun add_pool<RewardCoin>(
        _manager: &mut RewarderManager,
        _clmm_pool_id: ID,
        _allocate_point: u64,
        _clock: &Clock,
    ) {
        abort 0
    }

    public(friend) fun set_pool<RewardCoin>(
        _manager: &mut RewarderManager,
        _clmm_pool_id: ID,
        _allocate_point: u64,
        _clock: &Clock,
    ): u128 {
        abort 0
    }

    public(friend) fun pool_rewards_settle(
        _manager: &mut RewarderManager,
        _pool_reward_coins: vector<TypeName>,
        _clmm_pool_id: ID,
        _clock: &Clock,
    ): vec_map::VecMap<TypeName, u128> {
        abort 0
    }

    public(friend) fun set_pool_share(
        _manager: &mut RewarderManager,
        _clmm_pool_id: ID,
        _pool_share: u128,
    ) {
        abort 0
    }

    public(friend) fun withdraw_reward<RewardCoin>(
        _manager: &mut RewarderManager,
        _clmm_pool_id: ID,
        _amount: u64,
    ): balance::Balance<RewardCoin> {
        abort 0
    }

    public fun borrow_rewarder<RewardCoin>(
        _manager: &RewarderManager,
    ): &Rewarder {
        abort 0
    }

    public fun borrow_pool_share(_manager: &RewarderManager, _pool: ID): u128 {
        abort 0
    }

    public fun borrow_pool_rewarder_info(
        _rewarder: &Rewarder,
        _clmm_pool_id: ID
    ): &PoolRewarderInfo {
        abort 0
    }

    public fun borrow_pool_allocate_point(_manager: &RewarderManager, _reward_coin: TypeName, _clmm_pool_id: ID): u64 {
        abort 0
    }

    public fun pool_share(
        _manager: &RewarderManager,
        _clmm_pool_id: ID
    ): u128 {
        abort 0
    }

    public fun emission_per_second(_rewarder: &Rewarder): u128 {
        abort 0
    }

    public fun vault_balance<RewarderCoin>(_manager: &RewarderManager): u64 {
        abort 0
    }

    public fun total_allocate_point(_r: &Rewarder): u64 {
        abort 0
    }

    public fun last_reward_time(_m: &Rewarder): u64 {
        abort 0
    }

    public fun total_reward_released(_m: &Rewarder): u128 {
        abort 0
    }

    public fun total_reward_harvested(_m: &Rewarder): u64 {
        abort 0
    }

    public fun pool_last_reward_time(_p: &PoolRewarderInfo): u64 {
        abort 0
    }

    public fun pool_allocate_point(_p: &PoolRewarderInfo): u64 {
        abort 0
    }

    public fun pool_acc_per_share(_p: &PoolRewarderInfo): u128 {
        abort 0
    }

    public fun pool_reward_released(_p: &PoolRewarderInfo): u128 {
        abort 0
    }

    public fun pool_reward_harvested(_p: &PoolRewarderInfo): u64 {
        abort 0
    }

    fun is_pool_registered(_manager: &RewarderManager, _clmm_pool_id: ID): bool {
        abort 0
    }

    fun accumulate_rewarder_released(
        _rewarder: &mut Rewarder,
        _current_ts: u64
    ) {
        abort 0
    }

    fun accumulate_pools_reward<RewardCoin>(
        _manager: &mut RewarderManager,
        _current_ts: u64,
    ) {
        abort 0
    }

    fun accumulate_pool_reward(
        _rewarder: &mut Rewarder,
        _clmm_pool_id: ID,
        _pool_share: u128,
        _current_ts: u64,
    ): u128 {
        abort 0
    }

    fun is_pool_in_rewarder(
        _manager: &RewarderManager,
        _reward_coin: TypeName,
        _clmm_pool_id: ID
    ): bool {
        abort 0
    }

    #[test_only]
    public fun new_manager_for_test(_ctx: &mut TxContext): RewarderManager {
        abort 0
    }

    #[test_only]
    public fun register_pool_for_test(_manager: &mut RewarderManager, _clmm_pool_id: ID) {
        abort 0
    }

    #[test_only]
    public fun add_pool_for_test<RewardCoin>(
        _manager: &mut RewarderManager,
        _clmm_pool_id: ID,
        _allocate_point: u64,
        _clock: &Clock,
    ) {
        abort 0
    }

    #[test_only]
    public fun set_pool_for_test<RewardCoin>(
        _manager: &mut RewarderManager,
        _clmm_pool_id: ID,
        _allocate_point: u64,
        _clock: &Clock,
    ) {
        abort 0
    }

    #[test_only]
    public fun destory_rewarder_for_test(
        _rewarder: Rewarder
    ) {
        abort 0
    }

    #[test_only]
    public fun update_pool_share_for_test(
        _manager: &mut RewarderManager,
        _reward_coins: vector<TypeName>,
        _clmm_pool_id: ID,
        _pool_share: u128,
        _clock: &Clock,
    ): vec_map::VecMap<TypeName, u128> {
        abort 0
    }

    #[test_only]
    public fun withdraw_reward_for_test<RewardCoin>(
        _manager: &mut RewarderManager,
        _clmm_pool_id: ID,
        _amount: u64,
    ): balance::Balance<RewardCoin> {
        abort 0
    }

    #[test_only]
    struct RewardCoinA {}

    #[test_only]
    public fun add_pool_to_rewarder_for_test(
        _rewarder: &mut Rewarder,
        _pool_id: ID,
        _allocate_point: u64,
        _clk: &Clock
    ) {
        abort 0
    }
}
