# Cetus DCA

## What is Cetus DCA ?

Cetus DAC(Dollar Cost Averaging) can help users achieve the goal of purchasing a specific token at fixed intervals with a fixed amount, regardless of how the market price fluctuates.

## What is Cetus DCA Interface ?

The Cetus DCA Contract is used to record all user dca order information on our platform.

The Cetus DCA Interface is designed to facilitate developers who wish to integrate dca orders at the contract level. With just one line of code, you can integrate Cetus DCA into your smart contracts.

## How to Use the Cetus DCA Interface ?

### Tags corresponding to different networks

| Network | Latest published at address                                        |
| ------- | ------------------------------------------------------------------ |
| mainnet | 0x587614620d0d30aed66d86ffd3ba385a661a86aa573a4d579017068f561c6d8f |
| testnet | 0x484d2be08b58b8dc00a08c0ff8a2a9cd0542c4249ea2d5934ef9b15a10585d88 |

eg:

mainnet:

```
CetusDCA = { git = "https://github.com/CetusProtocol/cetus-clmm-interface.git", subdir = "sui/dca", rev = "mainnet", override = true }
```

testnet:

```
CetusDCA = { git = "https://github.com/CetusProtocol/cetus-clmm-interface.git", subdir = "sui/dca", rev = "testnet", override = true }
```

## Usage

Cetus DCA interface is not complete(just have function defination), so it will fails when sui clien check the code version. However, this does not affect its actual functionality. Therefore, we need to add a `--dependencies-are-root` during the build.

```bash
sui move build --dependencies-are-root && sui client publish --dependencies-are-root
```

## Process

Here is a complete workflow of the DCA process.
![DCA workflow](./dca.png)

## Function Description

We describe all parameters only when they appear for the first time.

### 1. open_order

First, the specified in coin type and out coin type uniquely determine the type of order. The orders indexer is used to index all orders of a certain type, similarly, creating a rate orders indexer is a prerequisite for placing a limit order.

#### Params:

- **config**: dca global config object.

  | Network | Global Config Object ID                                            |
  | ------- | ------------------------------------------------------------------ |
  | mainnet | 0x5db218756f8486fa2ac26fab590c4be4e439be54e6d932c9a30b20573a5b706a |
  | testnet | 0xdac150723df0b51c1407ea942036d7f9d4e3b064ff35a4136dd31ffb397497e0 |

- **in_coin**: The input coin object.
- **cycle_frequency**: Frequency of order execution (in seconds).
- **cycle_count**: Total cycle count of order execution.
- **min_out_amount_per_cycle**: Minimum amount of out_coin obtained per transaction.
- **max_out_amount_per_cycle**: Maximum amount of out_coin obtained per transaction.
- **in_amount_per_cycle**: Amount of in_coin per transaction (in_deposited divided by in_amount_per_cycle gives the
- **fee_rate**: Transaction fee rate (denominator is 1,000,000).
- **timestamp**: Current timestamp when order created.
- **signature**: Create by cetus quote service, it will check the `in_amount_per_cycle`,`fee_rate`, `timestamp`.
- **indexer**: the indexer about dca order orders

  | Network | orders indexer                                                     |
  | ------- | ------------------------------------------------------------------ |
  | mainnet | 0x713f0968d042b48f4ec57e4e21bd7e346d06355f59776faedc9497ca990a9f77 |
  | testnet | 0xacd0ab94883a8785c5258388618b6252f0c2e9384b23f91fc23f6c8ef44d445c |

#### Code Example:

```
public fun open_order<InCoin, OutCoin>(
    config: &GlobalConfig,
    in_coin: Coin<InCoin>,
    cycle_frequency: u64,
    cycle_count: u64,
    min_out_amount_per_cycle: u64,
    max_out_amount_per_cycle: u64,
    in_amount_limit_per_cycle: u64,
    fee_rate: u64,
    timestamp: u64,
    signature: String,
    clk: &Clock,
    indexer: &mut OrderIndexer,
    ctx: &mut TxContext
) {
    ...
}
```

### 2. withdraw

As the function name suggests, users can withdraw already execute dca order.

#### Code Example:

```
public fun withdraw<InCoin, OutCoin>(
    config: &GlobalConfig,
    order: &mut Order<InCoin, OutCoin>,
    clk: &Clock,
    ctx: &mut TxContext
): Coin<OutCoin> {
    ...
}
```

### 3. cancle_order

Users can cancel their orders at any time and return both the executed and unexecuted portions.

```
public fun cancle_order<InCoin, OutCoin>(
    config: &GlobalConfig,
    order: &mut Order<InCoin, OutCoin>,
    indexer: &mut OrderIndexer,
    clk: &Clock,
    ctx: &mut TxContext
): (Coin<InCoin>, Coin<OutCoin>) {
    ...
}
```

## DCA Quote

This is used to validate the user's input parameters for the DCA order and to sign these parameters. As introduced in the initial workflow, before creating an order, users need to request a quote to generate the signature. When creating the order, the signature must be provided, and the contract will verify whether the signature is valid.

### /dca/quote

- Mainnet: http://api-sui.cetus.com/dca/quote
- Testnet: http://api-sui.devcetus.com/dca/quote

```
curl http://api-sui.cetus.com/dca/quote?in_coin=0x0000000000000000000000000000000000000000000000000000000000000002::sui::SUI&freq=120&count=10&sender={user_address}
{
    "code": 200,
    "data": {
        "amount_in_limit": 9744545921,
        "coin_type": "0x0000000000000000000000000000000000000000000000000000000000000002::sui::SUI",
        "signature": "00dee6e2fe5f0c5c1e703f6ae9ce8995fde7a4b88f994f2dd8f81fd0eae3ad7b339ff803cb8ab25630a0fc19351e8b7c13b5212df634b9bd361c7ac6f0bde31a079d14900643e10df9eb3b0fac154df75f1d38650b4a741f4fc6b70a3cf2a9f6be",
        "signer": "{user_address}",
        "fee_rate": 1000,
        "timestamp": 1723626105
    },
    "msg": "Success"
}
```
