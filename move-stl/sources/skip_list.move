module move_stl::skip_list {
    use sui::object::UID;
    use move_stl::option_u64::OptionU64;
    use move_stl::random::Random;

    /// The skip list.
    struct SkipList<phantom V: store> has key, store {
        /// The id of this skip list.
        id: UID,
        /// The skip list header of each level. i.e. the score of node.
        head: vector<OptionU64>,
        /// The level0's tail of skip list. i.e. the score of node.
        tail: OptionU64,
        /// The current level of this skip list.
        level: u64,
        /// The max level of this skip list.
        max_level: u64,
        /// Basic probability of random of node indexer's level i.e. (list_p = 2, level2 = 1/2, level3 = 1/4).
        list_p: u64,

        /// The size of skip list
        size: u64,

        /// The random for generate ndoe's level
        random: Random,
    }
}