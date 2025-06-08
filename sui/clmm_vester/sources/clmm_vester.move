#[allow(unused_type_parameter, unused_field, unused_const)]
module clmm_vester::clmm_vester;

use cetusclmm::pool::{Pool};
use cetusclmm::position::{Position};
use clmm_vester::versioned::Versioned;
use std::type_name::{TypeName};
use sui::balance::{Balance};
use sui::clock::{Clock};
use sui::table;
use cetus::cetus::CETUS;

const BPS: u64 = 10000;
const PPM: u64 = 1000000;

public struct ClmmVester has key {
    id: UID,
    balance: Balance<CETUS>,
    global_vesting_periods: vector<GlobalVestingPeriod>,
    positions: table::Table<ID, PositionVesting>,
    total_value: u64,
    total_cetus_amount: u64,
    redeemed_amount: u64,
    start_time: u64,
}

public struct GlobalVestingPeriod has copy, drop, store {
    period: u16,
    release_time: u64,
    percentage: u64,
    redeemed_amount: u64,
}

public struct PositionVesting has copy, drop, store {
    position_id: ID,
    cetus_amount: u64,
    redeemed_amount: u64,
    coin_a: TypeName,
    coin_b: TypeName,
    impaired_a: u64,
    impaired_b: u64,
    period_details: vector<PeriodDetail>,
    is_paused: bool,
}

public struct PeriodDetail has copy, drop, store {
    period: u64,
    cetus_amount: u64,
    is_redeemed: bool,
}


public fun redeem<CoinTypeA, CoinTypeB>(
    _versioned: &Versioned,
    _clmm_vester: &mut ClmmVester,
    _pool: &Pool<CoinTypeA, CoinTypeB>,
    _position_nft: &mut Position,
    _period: u16,
    _clk: &Clock,
): Balance<CETUS> {
    abort 0
}

public fun get_positions_vesting<CoinTypeA, CoinTypeB>(
    _clmm_vester: &ClmmVester,
    _pool: &Pool<CoinTypeA, CoinTypeB>,
    _position_ids: vector<ID>,
): vector<PositionVesting> {
    abort 0
}

public fun get_position_vesting<CoinTypeA, CoinTypeB>(
    _clmm_vester: &ClmmVester,
    _pool: &Pool<CoinTypeA, CoinTypeB>,
    _position_id: ID,
): PositionVesting {
    abort 0
}

public fun start_time(clmm_vester: &ClmmVester): u64 {
    clmm_vester.start_time
}

public fun total_value(clmm_vester: &ClmmVester): u64 {
    clmm_vester.total_value
}

public fun total_cetus_amount(clmm_vester: &ClmmVester): u64 {
    clmm_vester.total_cetus_amount
}

public fun global_vesting_periods(clmm_vester: &ClmmVester): vector<GlobalVestingPeriod> {
    clmm_vester.global_vesting_periods
}

public fun borrow_position_vesting(
    clmm_vester: &ClmmVester,
    position_id: ID,
): PositionVesting {
    *clmm_vester.positions.borrow(position_id)
}

public fun period(global_vesting_period: &GlobalVestingPeriod): u16 {
    global_vesting_period.period
}

public fun release_time(global_vesting_period: &GlobalVestingPeriod): u64 {
    global_vesting_period.release_time
}

public fun percentage(global_vesting_period: &GlobalVestingPeriod): u64 {
    global_vesting_period.percentage
}

public fun position_cetus_amount(position_vesting: &PositionVesting): u64 {
    position_vesting.cetus_amount
}

public fun position_redeemed_amount(position_vesting: &PositionVesting): u64 {
    position_vesting.redeemed_amount
}

public fun position_period_details(position_vesting: &PositionVesting): vector<PeriodDetail> {
    position_vesting.period_details
}

public fun position_id(position_vesting: &PositionVesting): ID {
    position_vesting.position_id
}

public fun impaired_ab(position_vesting: &PositionVesting): (u64, u64) {
    (position_vesting.impaired_a, position_vesting.impaired_b)
}

public fun position_is_paused(position_vesting: &PositionVesting): bool {
    position_vesting.is_paused
}

public fun is_paused(position_vesting: &PositionVesting): bool {
    position_vesting.is_paused
}

public fun is_redeemed(period_detail: &PeriodDetail): bool {
    period_detail.is_redeemed
}

public fun detail_period(period_detail: &PeriodDetail): u64 {
    period_detail.period
}

public fun period_cetus_amount(period_detail: &PeriodDetail): u64 {
    period_detail.cetus_amount
}

public fun calculate_cut_liquidity(liquidity: u128, remove_percent: u64): u128 {
    let n = (liquidity as u256) * (remove_percent as u256);
    let r = (n  + ((PPM as u256) - 1)) / (PPM as u256);
    (r as u128)
}
