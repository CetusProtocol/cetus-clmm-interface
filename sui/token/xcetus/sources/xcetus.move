#[allow(unused_type_parameter, unused_field, unused_const)]
// This module is about:
// create the xcetus coin,
// provide the management of `VeNFT`,
// store the information about VeNFTs, and the update of these states of venfts.
// The VenftInfo list info is used for supporting the activities of higher level contracts.
// This module work with `locking` module.
// A `AdminCap` exists in this module, which can mint, burn xcetus in some situations.
module xcetus::xcetus {
    use sui::balance::Balance;
    use sui::tx_context::TxContext;
    use sui::coin::TreasuryCap;
    use sui::object::{UID, ID};
    use sui::table::Table;
    use move_stl::linked_table;

    friend xcetus::locking;

    const EBALANCE_NOT_ZERO: u64 = 1;
    const EBALANCE_NOT_MATCH: u64 = 2;
    const EBALANCE_AMOUNT_ERROR: u64 = 3;
    const EAVAILABLE_BALANCE_NOT_ENOUGH: u64 = 4;
    const EHAS_VENFT_ALREADY: u64 = 5;

    /// The witness of XCETUS Coin.
    struct XCETUS has drop {}

    /// The capability of the xcetus module, can mint, burn, transfer xcetus if needed.
    struct AdminCap has key, store {
        id: UID
    }

    /// Store the `Treasury` object of xCETUS Coin, and record all venfts's info.
    struct XcetusManager has key {
        id: UID,
        index: u64,
        has_venft: Table<address, bool>,
        nfts: linked_table::LinkedTable<ID, VeNftInfo>,
        treasury: TreasuryCap<XCETUS>,
        total_locked: u64,
    }

    /// The venft info stored in XcetusManager which is used for support dividends, maker-bonus and other future higher level activities.
    struct VeNftInfo has store, drop {
        id: ID,
        xcetus_amount: u64,
        lock_amount: u64,
    }

    /// The Venft Object which cannot be transfered, and holding the xCETUS.
    struct VeNFT has key {
        id: UID,
        index: u64,
        xcetus_balance: Balance<XCETUS>
    }

    // ============= Events =================
    struct MintVeNFTEvent has copy, drop, store {
        nft_id: ID,
        index: u64,
    }

    struct BurnVeNFTEvent has copy, drop, store {
        nft_id: ID,
    }

    struct MintEvent has copy, drop, store {
        nft_id: ID,
        amount: u64
    }

    struct BurnEvent has copy, drop, store {
        nft_id: ID,
        amount: u64
    }

    struct TransferEvent has copy, drop, store {
        from_venft: ID,
        to_venft: ID,
        amount: u64
    }

    /// Mint Venft.
    public fun mint_venft(_: &mut XcetusManager, _: &mut TxContext): ID {
        abort 0
    }

    /// Burn Venft when the xcetus balance owned is zero.
    public fun burn_venft(_: &mut XcetusManager, _: VeNFT, _: &mut TxContext) {
        abort 0
    }

    /// Getter `xcetus_amount` of VenftInfo.
    public fun xcetus_amount(_: &VeNftInfo): u64 {
        abort 0
    }

    /// Getter `lock_amount` of VenftInfo.
    public fun lock_amount(_: &VeNftInfo): u64 {
        abort 0
    }

    /// Getter the xCETUS amount of Venft.
    public fun value(_: &XcetusManager, _: &VeNFT): u64 {
        abort 0
    }

    /// Getter the unlocked xcetus amount of venft.
    public fun available_value(_: &XcetusManager, _: &VeNFT): u64 {
        abort 0
    }

    /// Getter total amount of xCETUS.
    public fun totol_amount(_: &XcetusManager): u64 {
        abort 0
    }

    /// Getter total locked xCETUS amount.
    public fun total_locked(_: &XcetusManager): u64 {
        abort 0
    }

    /// Getter total venfts
    public fun total_holder(_: &XcetusManager): u64 {
        abort 0
    }

    /// Getter all VenftInfo.
    public fun nfts(_: &XcetusManager): &linked_table::LinkedTable<ID, VeNftInfo> {
        abort 0
    }
}

