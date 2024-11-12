module cetus::cetus {
    use sui::tx_context::TxContext;
    use sui::object::ID;

    struct CETUS has drop {}

    #[allow(unused_field)]
    struct InitEvent has copy, drop {
        cap_id: ID,
        metadata_id: ID,
    }

    fun init(_witness: CETUS, _ctx: &mut TxContext) {
        abort 0
    }
}
