# Cetus clmm interface

<a name="readme-top"></a>
![GitHub Repo stars](https://img.shields.io/github/stars/CetusProtocol/cetus-clmm-interface?logo=github)

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <h3 align="center">Cetus-CLMM-INTERFACE</h3>

  <p align="center">
    Integrating Cetus-CLMMPOOL: A Comprehensive Guide
    <br />
    <a href="https://cetus-1.gitbook.io/cetus-docs/"><strong>Explore the docs »</strong></a>
<br />
    <br />
    ·
    <a href="https://github.com/CetusProtocol/cetus-clmm-interface/issues">Report Bug</a>
    ·
    <a href="https://github.com/CetusProtocol/cetus-clmm-interface/issues">Request Feature</a>
  </p>
</div>

## Projects

### Latest Published At Table

- **Mainnet**

  | Contract       | Latest published at address                                        |
  | -------------- | ------------------------------------------------------------------ |
  | cetus_clmm     | 0x157468379cfe5616c063ae39a889dd184ad48350d3e08f8d9b4ade22b8e3fb61 |
  | lp_burn        | 0xb92ae17938cde6d856ee39c686d4cfb968c94155e59e24520fbf60de38ebcd21 |
  | dca            | 0x587614620d0d30aed66d86ffd3ba385a661a86aa573a4d579017068f561c6d8f |
  | limitorder     | 0x533fab9a116080e2cb1c87f1832c1bf4231ab4c32318ced041e75cc28604bba9 |
  | stable_farming | 0x585381670c3d7c1f78caeb6c803f449442659743f4047a01b942da08bbfa19f6 |
  | xcetus         | 0x9e69acc50ca03bc943c4f7c5304c2a6002d507b51c11913b247159c60422c606 |
  | dividends      | 0xcec352932edc6663a118e8d64ed54da6b8107e8719603bf728f80717592cd9e8 |
  | vaults         | 0x1ed1fef522ccea98a4fbd954543d5019238ec89282fbdea9a753e0a17e96fc28 |

- **Testnet**

  | Contract       | Latest published at address                                        |
  | -------------- | ------------------------------------------------------------------ |
  | cetus_clmm     | 0xf3f49b91b82441ad017addff46d6d9a5867a755a86fb2374067fec19d6cc82c2 |
  | lp_burn        | 0x3b494006831b046481c8046910106e2dfbe0d1fa9bc01e41783fb3ff6534ed3a |
  | dca            | 0xacd0ab94883a8785c5258388618b6252f0c2e9384b23f91fc23f6c8ef44d445c |
  | limitorder     | 0xc65bc51d2bc2fdbce8c701f8d812da80fb37dba9cdf97ce38f60ab18c5202b17 |
  | stable_farming | 0xcc38686ca84d1dca949b6966dcdb66b698b58a4bba247d8db4d6a3a1dbeca26e |
  | xcetus         | 0xdebaab6b851fd3414c0a62dbdf8eb752d6b0d31f5cfce5e38541bc6c6daa8966 |
  | dividends      | 0x20d948d640edd0c749f533d41efc5f843f212d441220324ad7959c6e1d281828 |
  | vaults         | 0x325b7d67276ff809df6b3fa17a2a6fbff6aaa20e467c3cf74d1a1d09b8890bbd |

### Cetus CLMM

The Cetus CLMM Interface provider all core features function interface of CLMM, allowing users to easily connect with CLMM by contract. For more detailed information, please refer to the CLMM README document. [CLMM README Document](./sui/cetus_clmm/README.md)

### LP Burn

The Cetus LP Burn integrate all core lp burn interface of Stable Farming, For more detailed information, please refer to the Stable Farming README document. [Stable Farming README Document](./sui/lp_burn/README.md)

### Stable Farming

The Cetus Stable Farming integrate all core features function interface of Stable Farming, For more detailed information, please refer to the Stable Farming README document. [Stable Farming README Document](./sui/stable_farming/README.md)

### Token

The Cetus Token Interface integrates cetus, xcetus, dividends. For more detailed information, please refer to the Token README document. [Token README Document](./sui/token/README.md)

### Limit Order

The Cetus Limit Order seamlessly integrates all core functionalities of the Limit Order interface. For more detailed information, please refer to the Limit Order README document. [Limit Order README Document](./sui/limitorder/README.md)

### DCA

The Cetus DCA integrates all core functionalities of the DCA interface. For more detailed information, please refer to the DCA README document. [DCA README Document](./sui/dca/README.md)

### Vaults

The Cetus vaults integrates all core functionalities of the vaults interface. For more detailed information, please refer to the Vaults README document. [Vaults README Document](./sui/vaults/README.md)

## How to migrate to the latest version?

### Why need to migrate?

Cetus has already updated to the new CLMM contract and will disable the old version of the CLMM contract. The following contracts will need to be updated simultaneously:
integrate, stable farming, vault, aggregator, lp burn.

### Clmm contract update details

This update introduces new methods for pool creation, with the primary change being mandatory full-range liquidity provision for new pools. To create a new pool, you can use either:

- **pool_creator.create_pool_v2** on the cetus_clmm contract
- **pool_creator.create_pool_v2** on the integrate contract

**Note**: The previous creation method factory.create_pool is permissioned, and factory.create_pool_with_liquidity is deprecated in this update.

```rust
public fun create_pool_v2<CoinTypeA, CoinTypeB>(
  config: &GlobalConfig,
  pools: &mut Pools,
  tick_spacing: u32,
  initialize_price: u128,
  url: String,
  tick_lower_idx: u32,
  tick_upper_idx: u32,
  coin_a: Coin<CoinTypeA>,
  coin_b: Coin<CoinTypeB>,
  metadata_a: &CoinMetadata<CoinTypeA>,
  metadata_b: &CoinMetadata<CoinTypeB>,
  fix_amount_a: bool,
  clock: &Clock,
  ctx: &mut TxContext
): (Position, Coin<CoinTypeA>, Coin<CoinTypeB>)

public entry fun create_pool_v2<CoinTypeA, CoinTypeB>(
  config: &GlobalConfig,
  pools: &mut Pools,
  tick_spacing: u32,
  initialize_price: u128,
  url: String,
  coin_a: &mut Coin<CoinTypeA>,
  coin_b: &mut Coin<CoinTypeB>,
  metadata_a: &CoinMetadata<CoinTypeA>,
  metadata_b: &CoinMetadata<CoinTypeB>,
  fix_amount_a: bool,
  clock: &Clock,
  ctx: &mut TxContext
)
```

In these two methods, you can use the fix_amount_a parameter to control which coin amount remains fixed:

If `fix_amount_a` is true: The amount of coin_a will be fixed. You should provide the exact amount of coin_a you want to deposit, and the required amount of coin_b will be calculated automatically.
If `fix_amount_a` is false: The amount of coin_b will be fixed. You should provide the exact amount of coin_b you want to deposit, and the required amount of coin_a will be calculated automatically.

In some situations, coin issuers may want to reclaim the capability to create pools, so the protocol implements a `PoolCreationCap` mechanism for coin issuers. Here's how it works:
Prerequisites:

- You must hold the `TreasuryCap` of the coin
- The `TreasuryCap` must not be frozen
- Only one `PoolCreationCap` can be minted per coin

Steps to create a restricted pool:

1. Mint a `PoolCreationCap` using your coin's `TreasuryCap`

2. Register a pool by specifying: **Quote coin** and **Tick spacing**.

The protocol controls which quote coins and tick_spacing values are permitted for pool registration.
Currently, only pools with the SUI-200 can be registered.

```rust
let pool_creator_cap = factory::mint_pool_creation_cap<T>(
    clmm_global_config,
    clmm_pools,
    &mut treasury_cap,
    ctx
);

factory::register_permission_pair<T, SUI>(
    clmm_global_config,
    clmm_pools,
    CETUS_CLMMPOOL_TICKSPACING,
    &pool_creator_cap,
    ctx
);


let (lp_position, return_coin_a, return_coin_b) = pool_creator::create_pool_v2_by_creation_cap<T, SUI>(
  clmm_global_config,
  clmm_pools,
  pool_creator_cap,
  200,
  current_sqrt_price,
  string::utf8(b""),
  coin_a,
  coin_b,
  metadata_a,
  metadata_b,
  is_fix_a,
  clk,
  ctx
);
```

**Important Notice**: Mandatory Contract Upgrade
The Cetus CLMM core contract will undergo a mandatory upgrade in the near future. Upon completion:

Previous versions of the contract will be deprecated and no longer accessible
All dependent protocols will require updates, including:

- [Vaults](sui/vaults/)
- [StableFarming](sui/stable_farming/)
- [LPBurn](sui/lp_burn/)
- Aggregator
- Integrate

Please ensure all necessary preparations are made before the upgrade takes effect.

# More About Cetus

Use the following links to learn more about Cetus:

Learn more about working with Cetus in the [Cetus Documentation](https://cetus-1.gitbook.io/cetus-docs).

Join the Cetus community on [Cetus Discord](https://discord.com/channels/1009749448022315008/1009751382783447072).
