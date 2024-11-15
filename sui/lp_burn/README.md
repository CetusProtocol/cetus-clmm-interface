# Cetus LP Burn Docs

The primary functionality of this project, nominally referred to as "LP Burn," is essentially designed for users who wish to permanently lock their liquidity positions. Once locked, the liquidity within these positions cannot be withdrawn, yet users retain the ability to claim any transaction fees and mining rewards generated from these positions. This locking mechanism is implemented by wrapping the original position, effectively sealing the liquidity while still allowing the accrual of rewards. The Cetus LP Burn SDK is particularly tailored for projects that have established liquidity pools and wish to relinquish their liquidity rights. This feature allows these projects to commit to their community and ecosystem by locking liquidity permanently, thus providing stability and trust in the liquidity pool's longevity.

## Tags corresponding to different networks

| Tag of Repo     | Network | Latest published at address                                        | Package ID                                                         |
| --------------- | ------- | ------------------------------------------------------------------ | ------------------------------------------------------------------ |
| mainnet-v1.24.0 | mainnet | 0xb92ae17938cde6d856ee39c686d4cfb968c94155e59e24520fbf60de38ebcd21 | 0x12d73de9a6bc3cb658ec9dc0fe7de2662be1cea5c76c092fcc3606048cdbac27 |
| testnet-v1.24.0 | testnet | 0x63f7b16b3d828d8cc34ab49bb9b7da0432b06c925701fa07360388aef2dce83b | 0x3b494006831b046481c8046910106e2dfbe0d1fa9bc01e41783fb3ff6534ed3a |

eg:

mainnet:

```
LpBurn = { git = "https://github.com/CetusProtocol/cetus-clmm-interface.git", subdir = "sui/lp_burn", rev = "mainnet-v1.24.0", override = true }
```

testnet:

```
LpBurn = { git = "https://github.com/CetusProtocol/cetus-clmm-interface.git", subdir = "sui/lp_burn", rev = "testnet-v1.24.0", override = true }
```

## 1. Key Structures

- **BurnManager**: Manager for burning LP.

  ```move
  public struct BurnManager has key {
  id: UID,
  position: Table<ID, Table<ID, BurnedPositionInfo>>,
  must_full_range: bool,
  package_version: u64
  }
  ```

- **CetusLPBurnProof**: Proof of burning LP.

  ```move
  public struct CetusLPBurnProof has key, store {
     id: UID,
     name: String,
     description: String,
     image_url: String,
     position: Position
  }
  ```

- **BurnedPositionInfo**: Information of burned position.

  ```move
  public struct BurnedPositionInfo has store {
     burned_position_id: ID,
     position_id: ID,
     pool_id: ID
  }
  ```

## 2. User Operations

1. Burn LP.
   When the position is burned, a `CetusLPBurnProof` will be returned.

   ```move
   public fun burn_lp<A,B>(
      manager: &mut BurnManager,
      pool: &Pool<A,B>,
      position: Position,
      ctx: &mut TxContext
   ): CetusLPBurnProof {}
   ```

2. Burn.
   The entry function to burn position, it will auto transfer `CetusLPBurnProof` to tx sender.

   ```move
   public entry fun burn<A,B>(
      manager: &mut BurnManager,
      pool: &Pool<A,B>,
      position: Position,
      ctx: &mut TxContext
   ) {}
   ```

3. Collect fee.
   `CetusLPBurnProof` holder can collect lp fee.

   - `config`: This is clmm global config.

   ```move
   public fun collect_fee<CoinTypeA, CoinTypeB>(
      m: &BurnManager,
      config: &GlobalConfig,
      pool: &mut Pool<CoinTypeA, CoinTypeB>,
      position: &mut CetusLPBurnProof,
      ctx: &mut TxContext,
   ): (Coin<CoinTypeA>, Coin<CoinTypeB>) {}
   ```

4. Collect reward.
   `CetusLPBurnProof` holder can collect reward.

   ```move
   public fun collect_reward<CoinTypeA, CoinTypeB, CoinTypeC>(
      m: &BurnManager,
      config: &GlobalConfig,
      pool: &mut Pool<CoinTypeA, CoinTypeB>,
      position_nft: &mut CetusLPBurnProof,
      vault: &mut RewarderGlobalVault,
      clock: &Clock,
      ctx: &mut TxContext,
   ): Coin<CoinTypeC> {}
   ```

## 4. OnChain Objects ID

1. Mainnet

   ```text
   BurnManager: 0x1d94aa32518d0cb00f9de6ed60d450c9a2090761f326752ffad06b2e9404f845
   GlobalConfig(clmm): 0xce7bceef26d3ad1f6d9b6f13a953f053e6ed3ca77907516481ce99ae8e588f2b
   RewarderGlobalVault(clmm): 0xce7bceef26d3ad1f6d9b6f13a953f053e6ed3ca77907516481ce99ae8e588f2b
   ```

2. Testnet

   ```text
   BurnManager: 0xd04529ef15b7dad6699ee905daca0698858cab49724b2b2a1fc6b1ebc5e474ef
   GlobalConfig(clmm): 0x9774e359588ead122af1c7e7f64e14ade261cfeecdb5d0eb4a5b3b4c8ab8bd3e
   RewarderGlobalVault(clmm): 0xf78d2ee3c312f298882cb680695e5e8c81b1d441a646caccc058006c2851ddea
   ```
