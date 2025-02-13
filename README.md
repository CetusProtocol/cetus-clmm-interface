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
  | cetus_clmm     | 0xc6faf3703b0e8ba9ed06b7851134bbbe7565eb35ff823fd78432baa4cbeaa12e |
  | lp_burn        | 0xb6ec861eec8c550269dc29a1662008a816ac4756df723af5103075b665e32e65 |
  | dca            | 0x587614620d0d30aed66d86ffd3ba385a661a86aa573a4d579017068f561c6d8f |
  | limitorder     | 0x533fab9a116080e2cb1c87f1832c1bf4231ab4c32318ced041e75cc28604bba9 |
  | stable_farming | 0x7e4ca066f06a1132ab0499c8c0b87f847a0d90684afa902e52501a44dbd81992 |
  | xcetus         | 0x9e69acc50ca03bc943c4f7c5304c2a6002d507b51c11913b247159c60422c606 |
  | dividends      | 0xcec352932edc6663a118e8d64ed54da6b8107e8719603bf728f80717592cd9e8 |
  | vaults         | 0x58e5de6e425397eeaf952d55c0f94637bee91b25d6138ce222f89cda0aefec03 |

- **Testnet**

  | Contract       | Latest published at address                                        |
  | -------------- | ------------------------------------------------------------------ |
  | cetus_clmm     | 0xb2a1d27337788bda89d350703b8326952413bd94b35b9b573ac8401b9803d018 |
  | lp_burn        | 0x9c751fccc633f3ebad2becbe7884e5f38b4e497127689be0d404b24f79d95d71 |
  | dca            | 0xacd0ab94883a8785c5258388618b6252f0c2e9384b23f91fc23f6c8ef44d445c |
  | limitorder     | 0xc65bc51d2bc2fdbce8c701f8d812da80fb37dba9cdf97ce38f60ab18c5202b17 |
  | stable_farming | 0x3c4582ee27a09f7e6c091022d0d279fdc8e54c1f782916bf135a71a8e8006aa5 |
  | xcetus         | 0xdebaab6b851fd3414c0a62dbdf8eb752d6b0d31f5cfce5e38541bc6c6daa8966 |
  | dividends      | 0x20d948d640edd0c749f533d41efc5f843f212d441220324ad7959c6e1d281828 |
  | vaults         | 0x04df17a109336491867f04df40ca8a77277bc6e382139e88ae0d0d267ac07905 |

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

This update introduces new methods for pool creation, with the primary change being mandatory liquidity provision for new pools. To create a new pool, you can use either:

- **pool_creator.create_pool_v2** on the cetus_clmm contract
- **pool_creator_v2.create_pool_v2** on the integrate contract

**Note**: The previous creation method `factory.create_pool` is permissioned, and `factory.create_pool_with_liquidity` is deprecated in this update. The `pool_creator.create_pool_v2_by_creation_cap` method is deprecated, please use `pool_creator.create_pool_v2_with_creation_cap`.

```rust
// cetus_clmm.pool_creator.create_pool_v2
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

// integrate.pool_creator_v2.create_pool_v2
public entry fun create_pool_v2<CoinTypeA, CoinTypeB>(
        config: &GlobalConfig,
        pools: &mut Pools,
        tick_spacing: u32,
        initialize_price: u128,
        url: String,
        tick_lower_idx: u32,
        tick_upper_idx: u32,
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
    200,
    &pool_creator_cap,
    ctx
);


let (lp_position, return_coin_a, return_coin_b) = pool_creator::create_pool_v2_with_creation_cap<T, SUI>(
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

Additionally, a new event `CollectRewardV2Event` has been added to the pool module.

**Important Notice**: Mandatory Contract Upgrade
The Cetus CLMM core contract will undergo a mandatory upgrade in the near future. Upon completion, previous versions of the contract will be deprecated and no longer accessible
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
