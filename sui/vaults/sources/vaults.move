#[allow(unused_type_parameter, unused_field, unused_const)]
module vaults::vaults {

    use std::type_name::{TypeName};

    use sui::bag::{Bag};
    use sui::clock::Clock;
    use sui::coin::{TreasuryCap, Coin};
    use sui::table::{Table};
    use sui::tx_context::{TxContext};
    use sui::object::{UID, ID};

    use cetus_clmm::config::GlobalConfig;
    use cetus_clmm::pool::{Pool};

    use stable_farming::pool::{
        WrappedPositionNFT,
        Pool as SFarmingPool,
    };
    use stable_farming::rewarder::RewarderManager;
    use stable_farming::config::GlobalConfig as SFarmingConfig;

    use vaults::acl;


    /// Package verison which is need update when upgrade package
    const VERSION: u64 = 5;

    /// the denominator of `Vault` protocol_fee.
    const PROTOCOL_FEE_DENOMINATOR: u64 = 10000;
    /// Max protocol fee(2000/10000 = 20%)
    const MAX_PROTOCOL_FEE_RATE: u64 = 2000;

    const PRICE_MULTIPER: u256 = 100000000000000000000;

    const UINT64_MAX: u256 = 18446744073709551616;
    /// Range is (0 - 255 / 2000 = 12.75%)
    const SLIPPAGE_DENOMINATOR: u64 = 2000;


    /// Vaults Acl Roles
    const ACL_CLAIM_PROTOCOL_FEE: u8 = 0;
    const ACL_REINVEST_MANAGER: u8 = 1;
    const ACL_REBALANCE_MANAGER: u8 = 2;
    const ACL_POOL_MANAGER: u8 = 3;

    /// Vault Status
    const STATUS_RUNNING: u8 = 1;
    const STATUS_REBALANCING: u8 = 2;

    /// Errors
    const EAmountOutBelowMinLimit: u64 = 1;
    const EPositionSizeError: u64 = 2;
    const EPackageVersionDeprecate: u64 = 3;
    const ETokenAmountOverflow: u64 = 4;
    const ETokenAmountIsZero: u64 = 5;
    const EPoolIsPause: u64 = 6;
    const EInvalidCoinType: u64 = 7;
    const ERebalanceAddLiquidityError: u64 = 8;
    const ETokenAmountNotEnough: u64 = 9;
    const EInvalidProtocolFeeRate: u64 = 10;
    const ENoProtocolFeeClaimPermission: u64 = 11;
    const ENoOperationManagerPermission: u64 = 12;
    const ENoPoolManagerPemission: u64 = 13;
    const ETreausyCapIllegal: u64 = 14;
    const EWrongPackageVersion: u64 = 15;
    const EQuotaReached: u64 = 16;
    const EVaultNotRunning: u64 = 17;
    const EVaultNotRebalancing: u64 = 18;
    const EQuotaTypeNameError: u64 = 19;
    const ESameCoinType: u64 = 20;
    const EInvalidCoinTypeSequence: u64 = 21;
    const ECoinPairExisted: u64 = 22;
    const ECoinPairNonExisted: u64 = 23;
    const EIncorrectFlashLoanAmount: u64 = 24;
    const EIncorrentRepay: u64 = 25;
    const EOraclePoolError: u64 = 26;
    const EFlashloanCountNonzero: u64 = 27;
    const EFinishRebalanceThresholdNotMatch: u64 = 28;
    const EHarvestAssetNotEnough: u64 = 29;
    const EInvalidVaultOperation: u64 = 30;

    /// The Admin Cap of the protocol, manager the ACL.
    struct AdminCap has key, store {
        id: UID
    }

    /// The Vaults manager
    struct VaultsManager has key, store {
        id: UID,
        // Vault index created.
        index: u64,
        package_version: u64,
        // Store the pool ids. Map vault_id to clmm pool_id.
        vault_to_pool_maps: Table<ID, ID>,
        // Store new_pool_key(<CoinTypeA, CoinTypeB>) -> OracleInfo
        // The OracleInfo is used when flash_loan assetA from vault to calculate the repay assetB amount.
        // The reinvest or rebalance is done by flash_loan way.
        price_oracles: Table<ID, OracleInfo>,
        acl: acl::ACL
    }

    struct OracleInfo has store, drop {
        clmm_pool: ID,
        slippage: u8,
    }

    /// The Vault.
    struct Vault<phantom T> has key, store {
        id: UID,
        /// Clmm pool ID
        pool: ID,
        /// The liquidity in the Vault
        liquidity: u128,
        /// The protocol fee
        protocol_fee_rate: u64,
        /// Indicate if the vault is paused, the pool can be paused when in emergency
        is_pause: bool,
        /// The `WrappedPositionNFT` hold in vault. the size is always 1.
        positions: vector<WrappedPositionNFT>,
        /// The `TreasuryCap` of the associated LP Token to mint LP Token.
        lp_token_treasury: TreasuryCap<T>,
        /// Store the fee and rewarders temporarily
        harvest_assets: Bag,
        /// Store the protocol fee
        protocol_fees: Bag,
        /// Max TVL based on quota_based_type can add to the vault
        max_quota: u128,
        /// status: STATUS_RUNNING | STATUS_REBALANCING
        /// Rebalancing operation can be divided into two steps: Open new Position and add liquidity as can as possible without swap,
        /// second step is rebalance the liquidity and add liquidity into position, this step can do multiple times if needed(when the liquidity is large),
        /// and the last time the status must be set to STATUS_RUNNING.
        status: u8,
        /// Quota based CoinType
        quota_based_type: TypeName,
        ///  When finish rebalance and change vault status to STATUS_RUNNING, assets amount of coin_a and coin_b in harvest_assets based on `quota_based_type` must less then `finish_rebalance_threshold`
        finish_rebalance_threshold: u64,
        ///  When finish rebalance and change vault status to STATUS_RUNNING, `flash_loan_count` must be 0.
        /// To avoid call flash_loan to satisfy `finish_rebalance_threshold` and then call rebalance to finishd the rebalance process.
        flash_loan_count: u8,
    }

    /// Emit when deposit
    struct DepositEvent has copy, drop {
        vault_id: ID,
        before_liquidity: u128,
        delta_liquidity: u128,
        before_supply: u64,
        lp_amount: u64,
    }

    /// Emit when remove
    struct RemoveEvent has copy, drop {
        vault_id: ID,
        lp_amount: u64,
        liquidity: u128,
        amount_a: u64,
        amount_b: u64,
        protocol_fee_a_amount: u64,
        protocol_fee_b_amount: u64
    }

    /// Deposit Token to `Vault` and return Lp Token to user.
    /// Params
    ///     - manager: `VaultManger`
    ///     - vault: `Vault`
    ///     - rewarder_manager: RewarderManager
    ///     - sfarming_config: FarmingConfig
    ///     - sfarming_pool: FarmingPool
    ///     - clmm_config: Clmm config
    ///     - clmm_pool: the Clmm pool associated to Vault is needed here to add liquidity.
    ///     - coin_a
    ///     - coin_b
    ///     - amount_a: work with fix_amount_a
    ///     - amount_b: work with fix_amount_b
    ///     - fix_amount_a: fix amount_a or amount_b
    ///     - clk: Clock
    public fun deposit<CoinTypeA, CoinTypeB, T>(
        _: &VaultsManager,
        _: &mut Vault<T>,
        _: &mut RewarderManager,
        _: &SFarmingConfig,
        _: &mut SFarmingPool,
        _: &GlobalConfig,
        _: &mut Pool<CoinTypeA, CoinTypeB>,
        _: Coin<CoinTypeA>,
        _: Coin<CoinTypeB>,
        _: u64,
        _: u64,
        _: bool,
        _: &Clock,
        _: &mut TxContext
    ): Coin<T> {
        abort 0
    }

    /// Remove liquidity: burn the Lp Token and remove asset to user.
    /// Params
    ///     - manager: `VaultManger`
    ///     - vault: `Vault`
    ///     - rewarder_manager: RewarderManager
    ///     - sfarming_config: FarmingConfig
    ///     - sfarming_pool: FarmingPool
    ///     - clmm_config: Clmm config
    ///     - clmm_pool: the Clmm pool associated to Vault is needed here to remove liquidity.
    ///     - coins: The Lp Token to burn
    ///     - lp_token_amount: The amount of lp Token to remove
    ///     - min_amount_a: the minimum coin_a return
    ///     - min_amount_b: the minimum coin_b return
    ///     - clk: Clock
    public fun remove<CoinTypeA, CoinTypeB, T>(
        _: &VaultsManager,
        _: &mut Vault<T>,
        _: &mut RewarderManager,
        _: &SFarmingConfig,
        _: &mut SFarmingPool,
        _: &GlobalConfig,
        _: &mut Pool<CoinTypeA, CoinTypeB>,
        _: &mut Coin<T>,
        _: u64,
        _: u64,
        _: u64,
        _: &Clock,
        _: &mut TxContext
    ): (Coin<CoinTypeA>, Coin<CoinTypeB>) {
       abort 0
    }

    /// Get Coin amounts by Lp Token amount
    /// 1. Calculate the delta_liquidity the lp_amount share deserved
    /// 2. Calculate the amount_a and amount_b from the delta_liquidity in clmm.
    /// Params
    ///     - vault: `Vault`
    ///     - pool: `CLmmpool`
    ///     - lp_amount: Lp Token amount
    public fun get_position_amounts<CoinTypeA, CoinTypeB, T>(
        _: &Vault<T>,
        _: &Pool<CoinTypeA, CoinTypeB>,
        _: u64,
    ): (u64, u64) {
       abort 0
    }


    /// The total_supply of Lp Token
    /// Params
    ///     - vault: Vault
    public fun total_token_amount<T>(_: &Vault<T>): u64 {
        abort 0
    }

}
