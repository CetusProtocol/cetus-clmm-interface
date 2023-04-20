module move_stl::linked_table {
    use std::option::Option;
    use sui::object::UID;
    const  EListNotEmpty: u64 = 0;

    struct LinkedTable<K: store + drop + copy, phantom V: store> has key, store {
        id: UID,
        head: Option<K>,
        tail: Option<K>,
        size: u64
    }
}
