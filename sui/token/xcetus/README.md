
## operations

> Step 1. initialize the LockManager.
 

`initialize` function:

```
public entry fun initialize<CoinA>(
        cap: &AdminCap,
        min_lock_day: u64,
        max_lock_day: u64,
        min_percent_numerator: u64,
        max_percent_numerator: u64,
        ctx: &mut TxContext
    )
```

