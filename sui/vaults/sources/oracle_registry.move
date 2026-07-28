#[allow(unused_type_parameter, unused_field, unused_const)]
module vaults::oracle_registry {

    use std::type_name::TypeName;

    use sui::object::{ID, UID};
    use sui::table::Table;


    public struct OracleRegistry has key {
        id: UID,
        prices: Table<TypeName, Price>,
        coin_infos: Table<TypeName, CoinInfo>,
    }

    public struct Price has copy, drop, store {
        price: u64,
        decimal: u8,
        last_update_time: u64,
    }

    public struct CoinInfo has drop, store {
        price_feed_id: vector<u8>,
        price_info_object_id: ID,
        max_age: u64,
        decimal: u8,
        slippage: u64,
    }

    public struct CoinInfoPyth2Key has copy, drop, store {
        coin_type: TypeName,
    }

    public fun contain_coin_info_pyth2(
        _: &OracleRegistry,
        _: TypeName,
    ): bool {
        abort 0
    }
}
