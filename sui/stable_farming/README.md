# Cetus StableFarming Docs

Farms supports the release of multiple rewarders; each rewarder has an emission speed represented by `emission_per_second` and distributes rewards among multiple clmmpools based on the pool's `pool_allocate_point`.
The allocation of a single pool rewarder to staked clmm positions is determined by the position share, which is calculated at the time of staking into the pool.

## Tags corresponding to different networks

| Tag of Repo     | Network | Latest published at address                                         | Package ID                                                         |
|-----------------| ------- |---------------------------------------------------------------------| ------------------------------------------------------------------ |
| mainnet-v1.25.0 | mainnet | 0x7e4ca066f06a1132ab0499c8c0b87f847a0d90684afa902e52501a44dbd81992  | 0x11ea791d82b5742cc8cab0bf7946035c97d9001d7c3803a93f119753da66f526 |
| testnet-v1.25.0 | testnet | 0x3c4582ee27a09f7e6c091022d0d279fdc8e54c1f782916bf135a71a8e8006aa5  | 0xcc38686ca84d1dca949b6966dcdb66b698b58a4bba247d8db4d6a3a1dbeca26e |

eg:

mainnet:

```
StableFarming = { git = "https://github.com/CetusProtocol/cetus-clmm-interface.git", subdir = "sui/stable_farming", rev = "mainnet-v1.25.0", override = true }
```

testnet:

```
StableFarming = { git = "https://github.com/CetusProtocol/cetus-clmm-interface.git", subdir = "sui/stable_farming", rev = "testnet-v1.25.0", override = true }
```

## 1. Key Structures

- **RewarderManager**: Singleton that creates a global object when the contract is deployed, holds the rewarder balance, and manages multiple `Rewarder` information through LinkedTable.

  ```move
  struct RewarderManager has key, store {
      id: UID,
      vault: Bag,
      pool_shares: LinkedTable<ID, u128>,
      rewarders: LinkedTable<TypeName, Rewarder>
  }
  ```

- **Rewarder**

  ```move
  struct Rewarder has store {
      reward_coin: TypeName,
      total_allocate_point: u64,
      emission_per_second: u128,
      last_reward_time: u64,
      total_reward_released: u128,
      total_reward_harvested: u64,
      pools: LinkedTable<ID, PoolRewarderInfo>
  }

  struct PoolRewarderInfo has store {
      allocate_point: u64,
      acc_per_share: u128,
      last_reward_time: u64,
      reward_released: u128,
      reward_harvested: u64
  }
  ```

- **Pool**

  ```move
  struct Pool has key, store {
      id: UID,
      clmm_pool_id: ID,
      effective_tick_lower: I32,
      effective_tick_upper: I32,
      sqrt_price: u128,
      total_share: u128,
      rewarders: vector<TypeName>,
      positions: LinkedTable<ID, WrappedPositionInfo>
  }

  struct WrappedPositionNFT has key, store {
      id: UID,
      pool_id: ID,
      clmm_postion: Position,
      url: String
  }

  /// Clmm Position
  struct Position has key, store {
      id: UID,
      pool: ID, // clmm pool id
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
  ```

## 2. Contract Structure

```text
acl.move: The ACL module
config.move: Global Config module
pool.move: Pool associated with clmmpool to record information about farming
rewarder.move: Global RewarderManager to manage multiple Rewarders
router.move: All Entry functions
```

## 3. User Operations

1. Deposit Clmm Position into Farming Pool.
   When the clmmpool is staked, a `WrappedPositionNFT` is sent to the user.

   ```move
   public entry fun deposit(
       global_config: &GlobalConfig,
       rewarder_manager: &mut RewarderManager,
       pool: &mut Pool,
       clmm_position: CLMMPosition,
       clk: &Clock,
       ctx: &mut TxContext
   )
   ```

2. Withdraw Clmm Position from Farms Pool. All rewarders should be harvested before withdrawal.
   This instruction should work with the harvest instruction; the harvest move call should be organized before the withdrawal move call in a single transaction.
   If the clmmpool of this position has two rewarders, two move calls of harvest should be included in the transaction.

   ```move
   public entry fun withdraw(
       global_config: &GlobalConfig,
       rewarder_manager: &mut RewarderManager,
       pool: &mut Pool,
       wrapped_position: WrappedPositionNFT,
       clk: &Clock,
       ctx: &TxContext
   )
   ```

3. Harvest farm rewarders

   ```move
   public entry fun harvest<RewardCoin>(
       global_config: &GlobalConfig,
       rewarder_manager: &mut RewarderManager,
       pool: &mut Pool,
       wrapped_position: &WrappedPositionNFT,
       clk: &Clock,
       ctx: &mut TxContext
   )
   ```

4. Add liquidity into the clmmpool position staked in Farms pool

   ```move
   public entry fun add_liquidity<CoinA, CoinB>(
       global_config: &GlobalConfig,
       clmm_global_config: &CLMMGlobalConfig,
       rewarder_manager: &mut RewarderManager,
       pool: &mut Pool,
       clmm_pool: &mut CLMMPool<CoinA, CoinB>,
       wrapped_position: &mut WrappedPositionNFT,
       coin_a: Coin<CoinA>,
       coin_b: Coin<CoinB>,
       amount_limit_a: u64,
       amount_limit_b: u64,
       delta_liquidity: u128,
       clk: &Clock,
       ctx: &mut TxContext,
   )
   ```

5. Add fixed coin liquidity into the clmmpool position staked in Farms pool

   ```move
   public entry fun add_liquidity_fix_coin<CoinA, CoinB>(
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
   )
   ```

6. Remove liquidity from the clmmpool position staked in Farms pool

   ```move
   public entry fun remove_liquidity<CoinA, CoinB>(
       global_config: &GlobalConfig,
       clmm_global_config: &CLMMGlobalConfig,
       rewarder_manager: &mut RewarderManager,
       pool: &mut Pool,
       clmm_pool: &mut CLMMPool<CoinA, CoinB>,
       wrapped_position: &mut WrappedPositionNFT,
       delta_liquidity: u128,
       min_amount_a: u64,
       min_amount_b: u64,
       clk: &Clock,
       ctx: &mut TxContext
   )
   ```

7. Collect clmm fee using `WrappedPositionNFT`

   ```move
   public entry fun collect_fee<CoinA, CoinB>(
       global_config: &GlobalConfig,
       clmm_global_config: &CLMMGlobalConfig,
       clmm_pool: &mut CLMMPool<CoinA, CoinB>,
       wrapped_position: &WrappedPositionNFT,
       ctx: &mut TxContext
   )
   ```

8. Collect clmm rewarder using `WrappedPositionNFT`

   ```move
   public entry fun collect_clmm_reward<RewardCoin, CoinA, CoinB>(
       global_config: &GlobalConfig,
       clmm_global_config: &CLMMGlobalConfig,
       clmm_pool: &mut CLMMPool<CoinA, CoinB>,
       warped_position: &WrappedPositionNFT,
       vault: &mut RewarderGlobalVault,
       reward_coin: Coin<RewardCoin>,
       clock: &Clock,
       ctx: &mut TxContext
   )
   ```

9. Close clmm position
   Before calling this instruction to close the clmm position, the possible existing multiple clmm rewarders should be collected, and possible multiple Farms rewarders should be harvested.
   So the `collect_clmm_reward` and `harvest` move calls should be organized with `close_position` into a single transaction.

   ```move
   public fun close_position<CoinA, CoinB>(
       global_config: &GlobalConfig,
       rewarder_manager: &mut RewarderManager,
       pool: &mut Pool,
       clmm_global_config: &CLMMGlobalConfig,
       clmm_pool: &mut CLMMPool<CoinA, CoinB>,
       wrapped_position: WrappedPositionNFT,
       min_amount_a: u64,
       min_amount_b: u64,
       clk: &Clock,
       ctx: &mut TxContext
   )
   ```

## 4. OnChain Contracts and Objects

1. Testnet

   ```text
   package_id: 0xcc38686ca84d1dca949b6966dcdb66b698b58a4bba247d8db4d6a3a1dbeca26e
   published_at: 0x3c4582ee27a09f7e6c091022d0d279fdc8e54c1f782916bf135a71a8e8006aa5

   RewardManager: 0x960c7800e301fd1e47b79037927b426db57b643bd2934f7069d81c2dae092230
   GlobalConfig: 0x499132a4baf342a0fe9528a3666a77b2aece3be129f4a3ada469fef4b9c34fb4
   CLmmGlobalConfig: 0x9774e359588ead122af1c7e7f64e14ade261cfeecdb5d0eb4a5b3b4c8ab8bd3e
   ```

2. Mainnet

   ```text
   package_id: 0x11ea791d82b5742cc8cab0bf7946035c97d9001d7c3803a93f119753da66f526
   published_at: 0x7e4ca066f06a1132ab0499c8c0b87f847a0d90684afa902e52501a44dbd81992

   RewardManager: 0xe0e155a88c77025056da08db5b1701a91b79edb6167462f768e387c3ed6614d5
   GlobalConfig: 0x21215f2f6de04b57dd87d9be7bb4e15499aec935e36078e2488f36436d64996e
   ClmmGlobalConfig: 0xdaa46292632c3c4d8f31f23ea0f9b36a28ff3677e9684980e4438403a67a3d8f
   ```

## 5. How to Fetch All Farms Pools

```move
struct CreatePoolEvent has drop, copy {
    pool_id: ID,
    clmm_pool_id: ID,
    sqrt_price: u128,
    effective_tick_lower: I32,
    effective_tick_upper: I32,
}
```

Query all events of type "{package_id}::pool::CreatePoolEvent", and all related Farms pool_id and clmm_pool_id will be returned.

## 6. How to Fetch the Latest Rewarders for WrappedPositionNFT

Simulate the `accumulated_position_rewards` instruction, which will emit the `AccumulatedPositionRewardsEvent`. Parsing the event will get multiple rewarders that the `WrappedPositionNFT` gets at the current time.

```move
public fun accumulated_position_rewards(
    global_config: &GlobalConfig,
    rewarder_manager: &mut RewarderManager,
    pool: &mut Pool,
    wrapped_position_id: ID,
    clk: &Clock,
) {
    emit struct AccumulatedPositionRewardsEvent has drop, copy {
        pool_id: ID,
        wrapped_position_id: ID,
        clmm_position_id: ID,
        rewards: vec_map::VecMap<TypeName, u64>
    }
}
```

## 7. Open Liquidity Position, Add Liquidity if Needed, and Deposit into Farms Pool in a Single Transaction

Organize open position, add liquidity, and deposit move calls into a single transaction.

```move
/// clmmpool::pool::open_position and get Clmm LP.
public fun open_position<CoinTypeA, CoinTypeB>(
    config: &GlobalConfig,
    pool: &mut Pool<CoinTypeA, CoinTypeB>,
    tick_lower: u32,
    tick_upper: u32,
    ctx: &mut TxContext
): Position;

/// integrate::pool_v2::add_liquidity_by_fix_coin.
public entry fun add_liquidity_by_fix_coin<CoinTypeA, CoinTypeB>(
    config: &GlobalConfig,
    pool: &mut Pool<CoinTypeA, CoinTypeB>,
    position_nft: &mut Position,
    coin_a: Coin<CoinTypeA>,
    coin_b: Coin<CoinTypeB>,
    amount_a: u64,
    amount_b: u64,
    fix_amount_a: bool,
    clock: &Clock,
    ctx: &mut TxContext
);

/// call farms::pool::deposit to deposit LP into Farms pool and get WrappedPositionNFT
public fun deposit(
    global_config: &GlobalConfig,
    rewarder_manager: &mut RewarderManager,
    pool: &mut Pool,
    clmm_position: CLMMPosition,
    clk: &Clock,
    ctx: &mut TxContext
): WrappedPositionNFT
```
