#[allow(unused_type_parameter, unused_field, unused_const)]
module vaults::router {

    use sui::clock::Clock;
    use sui::coin::{Coin};
    use sui::tx_context::{TxContext};

    use cetus_clmm::config::GlobalConfig;
    use cetus_clmm::pool::Pool;

    use farming::rewarder::RewarderManager;
    use farming::pool::Pool as SFarmingPool;
    use farming::config::GlobalConfig as SFarmingConfig;

    use vaults::vaults::{
        VaultsManager,
        Vault,
    };


    /// User deposit Asset into `Vault`
    #[allow(lint(public_entry))]
    public entry fun deposit<CoinTypeA, CoinTypeB, T>(
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
    )
    {
       abort 0
    }

    /// User Remove Asset from `Vault` by Lp Token
    #[allow(lint(public_entry))]
    public entry fun remove<CoinTypeA, CoinTypeB, T>(
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
    ) {
       abort 0
    }
}
