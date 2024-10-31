module cetus::cetus {
    use sui::tx_context::TxContext;
    use sui::object::ID;

    struct CETUS has drop {}

    struct InitEvent has copy, drop {
        cap_id: ID,
        metadata_id: ID,
    }

    fun init(witness: CETUS, ctx: &mut TxContext) {
        abort 0
    }
}
