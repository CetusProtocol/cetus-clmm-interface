module clmm_vester::versioned;

public struct Versioned has key, store {
    id: object::UID,
    version: u64,
}
