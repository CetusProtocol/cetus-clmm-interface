module cetus_clmm::position {
    use std::string::String;
    use std::type_name::TypeName;

    use sui::object::{UID, ID};
    use sui::package::{Self, Publisher};
    use sui::tx_context::{TxContext};

    use integer_mate::i32::I32;

    use move_stl::linked_table;

    use cetus_clmm::config::{GlobalConfig};

    struct PositionManager has store {
        tick_spacing: u32,
        position_index: u64,
        positions: linked_table::LinkedTable<ID, PositionInfo>
    }

    /// The Cetus clmmpool's position NFT.
    struct Position has key, store {
        id: UID,
        pool: ID,
        index: u64,
        coin_type_a: TypeName,
        coin_type_b: TypeName,
        name: String,
        description: String,
        url: String,
        tick_lower_index: I32,
        tick_upper_index: I32,
        liquidity: u128,
    }

    /// The Cetus clmmpool's position information.
    struct PositionInfo has store, drop, copy {
        position_id: ID,
        liquidity: u128,
        tick_lower_index: I32,
        tick_upper_index: I32,
        fee_growth_inside_a: u128,
        fee_growth_inside_b: u128,
        fee_owned_a: u64,
        fee_owned_b: u64,
        points_owned: u128,
        points_growth_inside: u128,
        rewards: vector<PositionReward>,
    }

    /// The Position's rewarder
    struct PositionReward has drop, copy, store {
        growth_inside: u128,
        amount_owned: u64,
    }

    public fun set_display(
        config: &GlobalConfig,
        publisher: &Publisher,
        description: String,
        link: String,
        website: String,
        creator: String,
        ctx: &mut TxContext
    ) {
        abort 0;
    }

    public fun inited_rewards_count(manager: &PositionManager, position_id: ID): u64 {
        abort 0
    }

    public fun fetch_positions(
        manager: &PositionManager, start: vector<ID>, limit: u64
    ): vector<PositionInfo> {
        abort 0
    }

    public fun pool_id(position_nft: &Position): ID {
        abort 0
    }

    public fun tick_range(position_nft: &Position): (I32, I32) {
        abort 0
    }

    public fun index(position_nft: &Position): u64 {
        abort 0
    }

    public fun name(position_nft: &Position): String {
        abort 0
    }

    public fun description(position_nft: &Position): String {
        abort 0
    }

    public fun url(position_nft: &Position): String {
        abort 0
    }

    public fun liquidity(position_nft: &Position): u128 {
        abort 0
    }

    public fun info_position_id(info: &PositionInfo): ID {
        abort 0
    }

    public fun info_liquidity(info: &PositionInfo): u128 {
        abort 0
    }

    public fun info_tick_range(info: &PositionInfo): (I32, I32){
        abort 0
    }

    public fun info_fee_growth_inside(info: &PositionInfo): (u128, u128) {
        abort 0
    }

    public fun info_fee_owned(info: &PositionInfo): (u64, u64){
        abort 0
    }

    public fun info_points_owned(info: &PositionInfo): u128 {
        abort 0
    }

    public fun info_points_growth_inside(info: &PositionInfo): u128 {
        abort 0
    }

    public fun info_rewards(info: &PositionInfo): &vector<PositionReward>{
        abort 0
    }

    public fun reward_growth_inside(reward: &PositionReward): u128 {
        abort 0
    }

    public fun reward_amount_owned(reward: &PositionReward): u64 {
        abort 0
    }

    public fun borrow_position_info(
        manager: &PositionManager,
        position_id: ID,
    ): &PositionInfo {
        abort 0
    }

    public fun is_empty(position_info: &PositionInfo): bool {
        abort 0
    }

    public fun check_position_tick_range(lower: I32, upper: I32, tick_spacing: u32) {
        abort 0;
    }

    public fun is_position_exist(manager: &PositionManager, position_id: ID): bool {
        abort 0
    }
}