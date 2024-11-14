#[allow(unused_type_parameter, unused_field, unused_const)]
module vaults::fetcher {

    use sui::object::ID;

    use cetus_clmm::pool::Pool;

    use vaults::vaults::Vault;


    /// Events
    struct LpTokenValueEvent has copy, drop {
        lp_amount: u64,
        amount_a: u64,
        amount_b: u64,
        clmm_pool: ID,
        vault_id: ID,
    }

    /// Get the Coin amounts by Lp Token amount.
    public entry fun get_position_amounts<CoinTypeA, CoinTypeB, T>(
        _: &Vault<T>,
        _: &Pool<CoinTypeA, CoinTypeB>,
        _: u64,
    ) {
        abort 1
    }
}