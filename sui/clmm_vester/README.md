# ClmmVester Contract Documentation

## Background

After the CLMM (Concentrated Liquidity Market Maker) protocol was attacked, this `ClmmVester` contract was created to compensate affected positions. It enables users to redeem CETUS compensation tokens over multiple linear **vesting periods**.

## Overview

The `ClmmVester` contract records and manages compensation for each position through a `PositionVesting` plan. Each plan contains several `PeriodDetail` entries representing vesting schedules. Users can call the `redeem` function once per vesting period to claim their portion of CETUS.

## Core Structures

### `ClmmVester`

Stores global vesting state and tracks individual position vesting plans.

```move
struct ClmmVester {
    id: UID,
    balance: Balance<CETUS>,
    global_vesting_periods: vector<GlobalVestingPeriod>,
    positions: table::Table<ID, PositionVesting>,
    total_value: u64,
    total_cetus_amount: u64,
    redeemed_amount: u64,
    start_time: u64,
}
```

### `GlobalVestingPeriod`

Defines when and what percentage of the total CETUS can be redeemed.

```move
struct GlobalVestingPeriod {
    period: u16,
    release_time: u64,
    percentage: u64,
    redeemed_amount: u64,
}
```

### `PositionVesting`

Tracks vesting status and CETUS entitlement for a single LP position.

```move
struct PositionVesting {
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
```

### `PeriodDetail`

Represents CETUS allocation and redemption status for a single vesting period.

```move
struct PeriodDetail {
    period: u64,
    cetus_amount: u64,
    is_redeemed: bool,
}
```

## Main Function

### `redeem<CoinTypeA, CoinTypeB>`

```move
public fun redeem<CoinTypeA, CoinTypeB>(
    versioned: &Versioned,
    clmm_vester: &mut ClmmVester,
    pool: &Pool<CoinTypeA, CoinTypeB>,
    position_nft: &mut Position,
    period: u16,
    clk: &Clock,
): Balance<CETUS>
```

#### Parameters

* `versioned`: Contract version info, use share object `Versioned` below.
* `clmm_vester`: The global vesting plan state.
* `pool`: The relevant pool of your Position.
* `position_nft`: User’s affected LP position.
* `period`: Target vesting period to redeem. from [0, 12]
* `clk`: On-chain clock for timestamp comparison.

## Mainnet Packages 
PackageID: 0x9d2f067d3b9d19ac0f8d2e5c2c393b1760232083e42005b2e5df39c06064d522
```
ClmmVester: 0xe255c47472470c03bbefb1fc883459c2b978d3ad29aa8ee0c8c1ec9753fa7d01
Versioned: 0x4f6f2f638362505836114f313809b834dafd58e3910df5110f6e54e4e35c929b
```