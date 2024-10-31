# Cetus Token Interface

Cetus, xCetus, Dividends

## Concepts

CETUS is the main token of the Cetus Protocol, while xCETUS is the Cetus escrowed token to unlock more utilities such as staking, governance, etc. CETUS can be converted into xCETUS instantly at any time, while xCETUS can be redeemed back to CETUS upon a vesting period. A different redemption ratio will be applied depending on the actual vesting duration selected.

Details: https://cetus-1.gitbook.io/cetus-docs/tokenomics/cetus

Dividends is the protocol to manage bonus about xcetus. User can use reedeem_v2 to collect multi bonus.

### VeNFT

VeNFT is used for holding the xCetus.

## Tags corresponding to different networks

1. XCetus

| Tag of Repo | Network | Latest published at address                                        |
| ----------- | ------- | ------------------------------------------------------------------ |
| mainnet     | mainnet | 0x9e69acc50ca03bc943c4f7c5304c2a6002d507b51c11913b247159c60422c606 |
| testnet     | testnet | 0xdebaab6b851fd3414c0a62dbdf8eb752d6b0d31f5cfce5e38541bc6c6daa8966 |

eg:

mainnet:

```
Xcetus = { git = "https://github.com/CetusProtocol/cetus-clmm-interface.git", subdir = "sui/token/xcetus", rev = "mainnet" }
```

testnet:

```
Xcetus = { git = "https://github.com/CetusProtocol/cetus-clmm-interface.git", subdir = "sui/token/xcetus", rev = "testnet" }
```

2. Dividend

| Tag of Repo | Network | Latest published at address                                        |
| ----------- | ------- | ------------------------------------------------------------------ |
| mainnet     | mainnet | 0xcec352932edc6663a118e8d64ed54da6b8107e8719603bf728f80717592cd9e8 |
| testnet     | testnet | 0x20d948d640edd0c749f533d41efc5f843f212d441220324ad7959c6e1d281828 |

eg:

mainnet:

```
Dividend = { git = "https://github.com/CetusProtocol/cetus-clmm-interface.git", subdir = "sui/token/dividend", rev = "mainnet" }
```

testnet:

```
Dividend = { git = "https://github.com/CetusProtocol/cetus-clmm-interface.git", subdir = "sui/token/dividend", rev = "testnet" }
```
