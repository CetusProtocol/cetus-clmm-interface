# Cetus LP Burn Docs

The primary functionality of this project, nominally referred to as "LP Burn," is essentially designed for users who wish to permanently lock their liquidity positions. Once locked, the liquidity within these positions cannot be withdrawn, yet users retain the ability to claim any transaction fees and mining rewards generated from these positions. This locking mechanism is implemented by wrapping the original position, effectively sealing the liquidity while still allowing the accrual of rewards. The Cetus LP Burn contract is particularly tailored for projects that have established liquidity pools and wish to relinquish their liquidity rights. This feature allows these projects to commit to their community and ecosystem by locking liquidity permanently, thus providing stability and trust in the liquidity pool's longevity.

## Integration

### Move Registry (Recommended)

**Package**: `@cetuspackages/lpburn`


Or using CLI:
```bash
mvr add @cetuspackages/lpburn
```

### Git Tags (Alternative)

If you prefer to use git tags, you can find all available versions in the [GitHub releases](https://github.com/CetusProtocol/cetus-clmm-interface/tags) or use:

```toml
# Check GitHub for the latest version tag
LpBurn = { git = "https://github.com/CetusProtocol/cetus-clmm-interface.git", subdir = "sui/lp_burn", rev = "[LATEST_TAG]", override = true }
```

Replace `[LATEST_TAG]` with the latest tag from the releases page.

> **Note**: Git tags may not always reflect the latest published versions. For the most up-to-date integration, Move Registry is recommended.

```

> **Note**: For the latest published addresses, visit [Move Registry](https://www.moveregistry.com/package/@cetuspackages/lpburn)

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

1. Burn LP V2 (**Recommended**).

   When the position is burned, a `CetusLPBurnProof` will be returned. Compared to the `burn_lp` function, this V2 version does not require the pool object as a parameter, making it more convenient to use. The function will automatically verify the position's validity through the position object itself. This design also allows users to create a pool, add liquidity, and burn the position all within one transaction.

   ```move
   public fun burn_lp_v2<A,B>(
      manager: &mut BurnManager,
      position: Position,
      ctx: &mut TxContext
   ): CetusLPBurnProof {}
   ```

2. Entry Burn LP V2 (**Recommended**).

   The entry function to burn position v2, it will auto transfer `CetusLPBurnProof` to tx sender.

   ```move
   public entry fun burn_v2<A,B>(
      manager: &mut BurnManager,
      position: Position,
      ctx: &mut TxContext
   ) {}
   ```

3. Burn LP.

   When the position is burned, a `CetusLPBurnProof` will be returned.

   ```move
   public fun burn_lp<A,B>(
      manager: &mut BurnManager,
      pool: &Pool<A,B>,
      position: Position,
      ctx: &mut TxContext
   ): CetusLPBurnProof {}
   ```

4. Entry Burn LP.

   The entry function to burn position, it will auto transfer `CetusLPBurnProof` to tx sender.

   ```move
   public entry fun burn<A,B>(
      manager: &mut BurnManager,
      pool: &Pool<A,B>,
      position: Position,
      ctx: &mut TxContext
   ) {}
   ```

5. Collect fee.

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

6. Collect reward.

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

7. Redeem compensation
  
   The holder of a `CetusLPBurnProof` can redeem the compensation.
    ```
    public fun redeem<CoinTypeA, CoinTypeB>(
        versioned: &Versioned,
        clmm_vester: &mut ClmmVester,
        pool: &Pool<CoinTypeA, CoinTypeB>,
        position_proof: &mut CetusLPBurnProof,
        period: u16,
        clock: &Clock,
        ctx: &mut TxContext,
    ): Coin<CETUS> {}
    ```

## 4. OnChain Objects ID

1. Mainnet

   ```text
   BurnManager: 0x1d94aa32518d0cb00f9de6ed60d450c9a2090761f326752ffad06b2e9404f845
   GlobalConfig(clmm): 0xdaa46292632c3c4d8f31f23ea0f9b36a28ff3677e9684980e4438403a67a3d8f
   RewarderGlobalVault(clmm): 0xce7bceef26d3ad1f6d9b6f13a953f053e6ed3ca77907516481ce99ae8e588f2b
   ```

2. Testnet

   ```text
   BurnManager: 0xd04529ef15b7dad6699ee905daca0698858cab49724b2b2a1fc6b1ebc5e474ef
   GlobalConfig(clmm): 0x9774e359588ead122af1c7e7f64e14ade261cfeecdb5d0eb4a5b3b4c8ab8bd3e
   RewarderGlobalVault(clmm): 0xf78d2ee3c312f298882cb680695e5e8c81b1d441a646caccc058006c2851ddea
   ```
