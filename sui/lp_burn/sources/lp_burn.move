/// Module: burn_position
#[allow(unused_type_parameter, unused_field)]
module lpburn::lp_burn {
    use cetusclmm::config::GlobalConfig;
    use cetusclmm::pool::Pool;
    use cetusclmm::position::Position;
    use cetusclmm::rewarder::RewarderGlobalVault;
    use integer_mate::i32::I32;
    use std::string::String;
    use sui::clock::Clock;
    use sui::coin::Coin;
    use sui::table::Table;

    // === Structs ===
    public struct AdminCap has key, store {
        id: UID,
    }

    public struct LP_BURN has drop {}

    public struct BurnManager has key {
        id: UID,
        position: Table<ID, Table<ID, BurnedPositionInfo>>,
        must_full_range: bool,
        package_version: u64,
    }

    public struct CetusLPBurnProof has key, store {
        id: UID,
        name: String,
        description: String,
        image_url: String,
        position: Position,
    }

    public struct BurnedPositionInfo has store {
        burned_position_id: ID,
        position_id: ID,
        pool_id: ID,
    }

    public struct BurnPositionEvent has copy, drop {
        position_id: ID,
        burned_position_id: ID,
        pool_id: ID,
    }

    public struct InitEvent has copy, drop {
        manager_id: ID,
        cap_id: ID,
    }

    public fun burn_lp<A, B>(
        _manager: &mut BurnManager,
        _pool: &Pool<A, B>,
        _position: Position,
        _ctx: &mut TxContext,
    ): CetusLPBurnProof {
        abort 0
    }

    public entry fun burn<A, B>(
        _manager: &mut BurnManager,
        _pool: &Pool<A, B>,
        _position: Position,
        _ctx: &mut TxContext,
    ) {
        abort 0
    }

    public fun burn_lp_v2(
        _manager: &mut BurnManager,
        _position: Position,
        _ctx: &mut TxContext,
    ): CetusLPBurnProof {
        abort 0
    }

    public entry fun burn_v2(
        _manager: &mut BurnManager,
        _position: Position,
        _ctx: &mut TxContext,
    ) {
        abort 0
    }

    public fun collect_fee<CoinTypeA, CoinTypeB>(
        _m: &BurnManager,
        _config: &GlobalConfig,
        _pool: &mut Pool<CoinTypeA, CoinTypeB>,
        _position: &mut CetusLPBurnProof,
        _ctx: &mut TxContext,
    ): (Coin<CoinTypeA>, Coin<CoinTypeB>) {
        abort 0
    }

    public fun collect_reward<CoinTypeA, CoinTypeB, CoinTypeC>(
        _m: &BurnManager,
        _config: &GlobalConfig,
        _pool: &mut Pool<CoinTypeA, CoinTypeB>,
        _position_nft: &mut CetusLPBurnProof,
        _vault: &mut RewarderGlobalVault,
        _clock: &Clock,
        _ctx: &mut TxContext,
    ): Coin<CoinTypeC> {
        abort 0
    }

    public fun package_version(): u64 {
        abort 0
    }

    public fun valid_full_range(_min_tick: I32, _max_tick: I32, _tick_spacing: u32) {
        abort 0
    }
}
