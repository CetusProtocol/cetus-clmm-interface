#[allow(unused_type_parameter, unused_field)]
// This module is used for locking coin in `LockedCoin` object which cannot be transfered.
// When the lock time ends, the user can unwrap the `Balance` from `LockedCoin`.
module xcetus::lock_coin {
    use std::type_name::TypeName;

    use sui::object::{UID, ID};
    use sui::balance::Balance;
    use sui::tx_context::TxContext;
    use sui::coin::Coin;
    use sui::clock::Clock;

    /// A coin of type `T` locked until `timestamp`.
    struct LockedCoin<phantom T> has key {
        id: UID,
        balance: Balance<T>,
        locked_start_time: u64,
        locked_until_time: u64
    }

    /// Events
    struct LockCoinEvent has copy, drop {
        type: TypeName,
        amount: u64,
        recipient: address,
        locked_until_time: u64,
    }

    struct UnlockCoinEvent has copy, drop {
        type: TypeName,
        amount: u64,
        locked_coin: ID,
        locked_until_time: u64,
    }

    /// Lock a coin up until `locked_until_time`. The input Coin<T> is wrapped and a LockedCoin<T>
    /// is transferred to the `recipient`. This function aborts if the `locked_until_time` is less than
    /// or equal to the current timestamp.
    public fun lock_coin<T>(
        _: Coin<T>,
        _: u64,
        _: u64,
        _: address,
        _: &mut TxContext
    ): ID {
        abort 0
    }

    /// Unlock a locked coin. The function aborts if the current timestamp is less than the `locked_until_time`
    /// of the coin. If the check is successful, the `LockedCoin` object is deleted and a Coin<T> is transferred back
    /// to the sender.
    public fun unlock_coin<T>(
        _: LockedCoin<T>,
        _: &Clock,
        _: &mut TxContext
    ): ID {
        abort 0
    }

    /// Public getter for the `LockedCoin` value
    public fun value<T>(_: &LockedCoin<T>): u64 {
        abort 0
    }

    /// Public getter for the `LockedCoin` locked_until_time
    public fun lock_time<T>(_: &LockedCoin<T>): u64 {
        abort 0
    }

    /// Delete the `LockedCoin` object.
    public fun destory_lock<T>(_: LockedCoin<T>): (Balance<T>, ID) {
        abort 0
    }
}

