module xcetus::utils {

    use sui::clock;
    use sui::coin::Coin;
    use sui::tx_context::TxContext;


    public fun now_timestamp(_clk: &clock::Clock): u64 {
        abort 1
    }

    public fun merge_coins<CoinType>(_coins: vector<Coin<CoinType>>, _ctx: &mut TxContext): Coin<CoinType> {
        abort 1
    }
}


