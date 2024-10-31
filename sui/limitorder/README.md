# Cetus LimitOrder Interface

## What is Cetus LimitOrder ?

Cetus LimitOrder offers a fast and convenient way to create limit orders on the Sui network, allowing users to flexibly buy and sell between any specified trading pairs at set prices. Cetus leverages the powerful capabilities of the Cetus Aggregator to monitor all available liquidity across the entire Sui chain in real-time, executing transactions as soon as market prices meet the user-defined order prices.

## What is Cetus LimitOrder Interface ?

The Cetus Limit Order Contract is used to record all user limit order information on our platform. All orders placed by users are stored in a shared object, and flash loans are provided to enable limit order bots to quickly utilize the assets in these orders. Through the powerful routing capabilities provided by the Cetus Aggregator, the orders are matched with all liquidity on SUI network.

The Cetus LimitOrder Interface is designed to facilitate developers who wish to integrate limit orders at the contract level. With just one line of code, you can integrate Cetus LimitOrder into your smart contracts.

## How to Use the Cetus LimitOrder Interface ?

### Tags corresponding to different networks

| Tag of Repo     | Network | Latest published at address                                        |
| --------------- | ------- | ------------------------------------------------------------------ |
| mainnet-v1.23.1 | mainnet | 0x533fab9a116080e2cb1c87f1832c1bf4231ab4c32318ced041e75cc28604bba9 |
| testnet-v1.23.1 | testnet | 0xc65bc51d2bc2fdbce8c701f8d812da80fb37dba9cdf97ce38f60ab18c5202b17 |

eg:

mainnet:

```
LimitOrder = { git = "https://github.com/CetusProtocol/cetus-clmm-interface.git", subdir = "sui/limitorder", rev = "mainnet-v1.23.1" }
```

testnet:

```
LimitOrder = { git = "https://github.com/CetusProtocol/cetus-clmm-interface.git", subdir = "sui/limitorder", rev = "testnet-v1.23.1" }
```

## Usage

Cetus limitorder interface is not complete(just have function defination), so it will fails when sui clien check the code version. However, this does not affect its actual functionality. Therefore, we need to add a `--dependencies-are-root` during the build.

```bash
sui move build --dependencies-are-root && sui client publish --dependencies-are-root
```

## Function Description

We describe all parameters only when they appear for the first time.

### 1. create_rate_orders_indexer

First, the specified pay coin type and target coin type uniquely determine the type of order. The rate orders indexer is used to index all orders of a certain type and group them by price. A rate orders indexer is only needed when creating this type of order for the first time; similarly, creating a rate orders indexer is a prerequisite for placing a limit order.

#### Params:

- config: limitorder global config object.

  | Network | Global Config Object ID                                            |
  | ------- | ------------------------------------------------------------------ |
  | mainnet | 0xd3403f23a053b52e5c4ef0c2a8be316120c435ec338f2596647b6befd569fd9c |
  | testnet | 0xd4d98f126233057b3a01f17adfb5bc77d7bdb0332fe982ab44c6c7a2f66443dc |

- rate_orders_indexers: the indexer about limit order rate orders indexer

  | Network | Rate orders indexer                                                |
  | ------- | ------------------------------------------------------------------ |
  | mainnet | 0x7de9db54893cd6f69aae7be7fa99362a820810278a234d87d109980e9cfce7c3 |
  | testnet | 0xeaa7dc3a4b70c14b434aed2cef0bdd272a781c630ea3c54c25fa53c72fb3cf96 |

#### Code Example:

```
public entry fun create_rate_orders_indexer<PayCoin, TargetCoin>(
    config: &GlobalConfig,
    rate_orders_indexers: &mut RateOrdersIndexers,
    clock: &Clock,
    ctx: &mut TxContext,
) {
    ...
}
```

### 2. place_limit_order

As the function name suggests, users can directly create a limit order through this method.

#### Params:

- config: limitorder global config object.

- rate_orders_indexer: the indexer about one specific type limit orders, key is rate. every pay coin type and target coin type corresponds to a unique rate orders indexer.

- user_orders_indexer: the indexer about limit orders, key is the owner address.

  | Network | User orders indexer                                                |
  | ------- | ------------------------------------------------------------------ |
  | mainnet | 0x7f851ac19e438f97e78a5335eed4f12766a3a0ae94340bab7956a402f0e6212e |
  | testnet | 0x18ff28ae25ea50c703a0dfcc49653cc7dd7035207e26c8f86fa9e4aea49037d0 |

- pay_coin: the all balance will be whole used to create limit order.

- rate: [how to calculate rate by `pay_amount` and `target_amount`](#rate-and-target-amount-calcucalculation-formulaalte).

- expire_ts: if this order will not be matched by limitorder bot utils expired time, it will auto be canceled, the coin will be send to owner.

#### Code Example:

```
public entry fun place_limit_order<PayCoin, TargetCoin>(
    config: &GlobalConfig,
    rate_orders_indexer: &mut RateOrdersIndexer<PayCoin, TargetCoin>,
    user_orders_indexer: &mut UserOrdersIndexer,
    pay_coin: Coin<PayCoin>,
    rate: u128,
    expire_ts: u64,
    clock: &Clock,
    ctx: &mut TxContext,
) {
    ...
}
```

### 3. create_indexer_and_place_limit_order

This method combines the creation of a rate orders indexer with the placement of a limit order, applicable only when a certain type of order does not yet exist in the entire limit order system.

```
public entry fun create_indexer_and_place_limit_order<PayCoin, TargetCoin>(
    config: &GlobalConfig,
    rate_orders_indexers: &mut RateOrdersIndexers,
    user_orders_indexer: &mut UserOrdersIndexer,
    pay_coin: Coin<PayCoin>,
    rate: u128,
    expire_ts: u64,
    clock: &Clock,
    ctx: &mut TxContext,
) {
    ...
}
```

### 4. claim_target_coin

Due to the large quantity involved in some limit orders, our bots may need to transact multiple times to fully execute an order. When a part of the order is executed, we allow the owner of the order to claim the portion executed at the set price.

```
public fun claim_target_coin<PayCoin, TargetCoin>(
    config: &GlobalConfig,
    limit_order: &mut LimitOrder<PayCoin, TargetCoin>,
    ctx: &mut TxContext,
) {
    ...
}
```

### 5. cancel_order_by_owner

For orders that have not been executed for a long time, we allow users to cancel them, and the assets in the order will be returned to the order's owner.

```
public fun cancel_order_by_owner<PayCoin, TargetCoin>(
    config: &GlobalConfig,
    rate_orders_indexer: &mut RateOrdersIndexer<PayCoin, TargetCoin>,
    limit_order: &mut LimitOrder<PayCoin, TargetCoin>,
    clock: &Clock,
    ctx: &mut TxContext,
) {
    ...
}
```

## View Function

### 1. get_orders_indexer_by_owner

Users can quickly find orders created by a specific owner through the order indexer.

## Rate and target amount Calcucalculation formulaalte

1. expected target amount calculation formula:

   $$
   \text{expect target amount} = \text{pay amount} \times \text{rate}
   $$

2. rate calculation formula

   $$
   \text{percision} = 10 ^ {18} \\
   $$

   $$
   \text{rate} = \frac{\text{pay amount} \times \text{percision}}{\text{target amount}}
   $$

3. explanation of the formula:

   - $\text{pay amount}$ is the amount of coin paid by the user.
   - $\text{rate}$ is the exchange rate for the currency conversion.
   - $\text{expect target amount}$ is the anticipated amount to be received, calculated based on the pay amount and the exchange rate.
   - $\text{target amount}$ is the amount of coin received by the user.
