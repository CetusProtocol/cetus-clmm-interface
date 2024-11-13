#[allow(unused_type_parameter, unused_field, unused_const, unused_use)]
module dividends::router {

    use xcetus::locking::LockUpManager;
    use dividends::dividend::{DividendManager, VeNFTDividends};
    use sui::tx_context::TxContext;
    use xcetus::xcetus::{XcetusManager, VeNFT};
    use sui::clock::Clock;
    use sui::object::ID;

    /// Redeem
    /// args
    ///     -`DividendManager`
    ///     - Venft
    public entry fun redeem<CoinA>(
        _: &mut DividendManager,
        _: &mut VeNFT,
        _: &mut TxContext
    ) {
        abort 1
    }

    /// RedeemV2
    /// args
    ///     -`DividendManager`
    ///     - Venft
    public entry fun redeem_v2<CoinA>(
        _: &mut DividendManager,
        _: &mut VeNFT,
        _: &Clock,
        _: &mut TxContext
    ) {
        abort 1
    }

    /// RedeemV3
    public entry fun redeem_v3<CoinA>(
        _: &mut DividendManager,
        _: &mut VeNFTDividends,
        _: vector<u64>,
        _: &mut VeNFT,
        _: &Clock,
        _: &mut TxContext
    )
    {
        abort 1
    }

    public entry fun fetch_dividend_info(_: &DividendManager, _: ID) {
        abort 1
    }

    public entry fun fetch_dividend_info_v2(_: &DividendManager, _: &VeNFTDividends, _: ID) {
        abort 1
    }
}
