module move_stl::option_u64 {
    const EOptionU64IsNone: u64 = 0;

    struct OptionU64 has copy, drop, store {
        is_none: bool,
        v: u64
    }
}
