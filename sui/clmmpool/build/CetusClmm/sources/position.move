module cetus_clmm::position {
    use std::string::String;
    use std::type_name::TypeName;

    use sui::object::{UID, ID};
    use sui::package::{Publisher};
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
        _config: &GlobalConfig,
        _publisher: &Publisher,
        _description: String,
        _link: String,
        _website: String,
        _creator: String,
        _ctx: &mut TxContext
    ) {
        abort 0
    }

    public fun inited_rewards_count(_manager: &PositionManager, _position_id: ID): u64 {
        abort 0
    }

    public fun fetch_positions(
        _manager: &PositionManager, _start: vector<ID>, _limit: u64
    ): vector<PositionInfo> {
        abort 0
    }

    public fun pool_id(_position_nft: &Position): ID {
        abort 0
    }

    public fun tick_range(_position_nft: &Position): (I32, I32) {
        abort 0
    }

    public fun index(_position_nft: &Position): u64 {
        abort 0
    }

    public fun name(_position_nft: &Position): String {
        abort 0
    }

    public fun description(_position_nft: &Position): String {
        abort 0
    }

    public fun url(_position_nft: &Position): String {
        abort 0
    }

    public fun liquidity(_position_nft: &Position): u128 {
        abort 0
    }

    public fun info_position_id(_info: &PositionInfo): ID {
        abort 0
    }

    public fun info_liquidity(_info: &PositionInfo): u128 {
        abort 0
    }

    public fun info_tick_range(_info: &PositionInfo): (I32, I32){
        abort 0
    }

    public fun info_fee_growth_inside(_info: &PositionInfo): (u128, u128) {
        abort 0
    }

    public fun info_fee_owned(_info: &PositionInfo): (u64, u64){
        abort 0
    }

    public fun info_points_owned(_info: &PositionInfo): u128 {
        abort 0
    }

    public fun info_points_growth_inside(_info: &PositionInfo): u128 {
        abort 0
    }

    public fun info_rewards(_info: &PositionInfo): &vector<PositionReward>{
        abort 0
    }

    public fun reward_growth_inside(_reward: &PositionReward): u128 {
        abort 0
    }

    public fun reward_amount_owned(_reward: &PositionReward): u64 {
        abort 0
    }

    public fun borrow_position_info(
        _manager: &PositionManager,
        _position_id: ID,
    ): &PositionInfo {
        abort 0
    }

    public fun is_empty(_position_info: &PositionInfo): bool {
        abort 0
    }

    public fun check_position_tick_range(_lower: I32, _upper: I32, _tick_spacing: u32) {
        abort 0
    }

    public fun is_position_exist(_manager: &PositionManager, _position_id: ID): bool {
        abort 0
    }
}