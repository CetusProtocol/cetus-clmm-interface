## Vaults

Vaults is a system specifically designed to automatically manage user liquidity. It encompasses the timely reinvestment
of fees and rewards, as well as rebalancing when necessary.

Vaults possesses the Farms WrappedPositionNFT. When a user deposits tokens into Vaults, those tokens are utilized to
provide liquidity within the positions held by Vaults.

As tokens are added to the respective positions, LP (Liquidity Provider) tokens are minted and allocated to users.

These LP tokens serve as a representation of the individual's share of liquidity within Vaults.

### How to calculate LP amount when deposit

```

          total_lp_amount                 the_lp_amount_mint_to_user
    --------------------------------  =   ------------------------------
    total_liqudity_in_vault_position      the_liqudiity_user_deposited

the_lp_amount_mint_to_user  = total_lp_amount *  the_liqudiity_user_deposited / total_liqudity_in_vault_position
```

### How to calculate the liquidity should remove to user given the lp amount user provided

```

          total_lp_amount                  the_lp_amount_user_provided
    --------------------------------  =    ----------------------------
    total_liqudity_in_vault_position       the_liquidity_give_to_user

the_liquidity_give_to_user = total_liqudity_in_vault_position * the_lp_amount_user_provided / total_lp_amount

```

### How to reinvest

1. collect_fee
2. collect clmm rewarders
3. swap clmm rewarders to vault token_a or token_b(flash loan way)
4. harvest farms rewarders
5. swap farms rewarders to vault token_a or token_b(flash loan way)
6. rebalance the token_a and token_b in vault bag
7. reinvest

### How to rebalance

1. collect clmm rewarders
2. harvest farms rewarders
1. remove all liquidity and collect fee, close position from farms `close_position` instruction
2. open position and deposit into farms pool
3. use `rebalance` to add liquidity into farms pool
4. use `finish_rebalance` to rebalance and add liquidity to farms pool; this operation can do multiple times if need,
   and the last time should set `is_finish` is true to finish rebalance


## ChangeLog
1. Fix bug
Tue, 11 Jun 2024 18:28:08 +0800

call collect_fee before deposit and remove.