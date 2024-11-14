// The router of the contract.
module xcetus::router {

    use xcetus::locking::LockUpManager;
    use xcetus::xcetus::{XcetusManager, VeNFT};
    use sui::coin::Coin;
    use sui::clock::Clock;
    use sui::tx_context::TxContext;
    use xcetus::lock_coin::LockedCoin;
    use sui::object::ID;
    use cetus::cetus::CETUS;


    /// convert.
    /// Convert CETUS to xCETUS.
    public entry fun convert(
        _: &mut LockUpManager,
        _: &mut XcetusManager,
        _: vector<Coin<CETUS>>,
        _: u64,
        _: &mut VeNFT,
        _: &mut TxContext
    ) {
        abort 1
    }

    public entry fun mint_and_convert(
        _: &mut LockUpManager,
        _: &mut XcetusManager,
        _: vector<Coin<CETUS>>,
        _: u64,
        _: &mut TxContext
    ) {
        abort 1
    }

    /// redeem_lock.
    /// Convert xCETUS to CETUS, first step is to lock the CETUS for a period.
    /// When the time is reach, xcetus can be redeem and xCETUS will be burned.
    public entry fun redeem_lock(
        _: &mut LockUpManager,
        _: &mut XcetusManager,
        _: &mut VeNFT,
        _: u64,
        _: u64,
        _: &Clock,
        _: &mut TxContext
    ) {
        abort 1
    }

    /// cancel_redeem_lock
    /// Cancel the redeem lock, the xcetus locked will be return back to the manager and the xCETUS will be available again.
    public entry fun cancel_redeem_lock(
        _: &mut LockUpManager,
        _: &mut XcetusManager,
        _: &mut VeNFT,
        _: LockedCoin<CETUS>,
        _: &Clock,
    ) {
        abort 1
    }

    /// redeem
    /// lock time is reach and the xcetus can be redeemed, the xCETUS will be burned.
    public entry fun redeem(
        _: &mut LockUpManager,
        _: &mut XcetusManager,
        _: &mut VeNFT,
        _: LockedCoin<CETUS>,
        _: &Clock,
        _: &mut TxContext
    ) {
        abort 1
    }

    /// burn_venft
    ///  args
    ///     - manager: XcetusManager share object.
    ///     - venft: VeNFT
    public entry fun burn_venft(_: &mut XcetusManager, _: VeNFT, _: &mut TxContext) {
        abort 1
    }

    /// mint venft
    /// args
    ///     - manager: XcetusManager share object.
    ///     - venft: VeNFT
    public entry fun mint_venft(_: &mut XcetusManager, _: &mut TxContext): ID {
        abort 1
    }
}

