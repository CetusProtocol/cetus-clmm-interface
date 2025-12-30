# Cetus CLMM Interface

<a name="readme-top"></a>
![GitHub Repo stars](https://img.shields.io/github/stars/CetusProtocol/cetus-clmm-interface?logo=github)

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <h3 align="center">Cetus CLMM Interface</h3>

  <p align="center">
    A comprehensive interface integration for Cetus CLMM protocol and related DeFi modules
    <br />
    <a href="https://cetus-1.gitbook.io/cetus-docs/"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/CetusProtocol/cetus-clmm-interface/issues">Report Bug</a>
    ·
    <a href="https://github.com/CetusProtocol/cetus-clmm-interface/issues">Request Feature</a>
  </p>
</div>

## Projects

### Available Contracts

> **📦 Get the latest version from Move Registry**
>
> All Cetus contracts are published on Move Registry. This is the recommended way to get the latest package versions and published addresses.

| Contract          | Move Registry Package                                                                         | Integration                          |
| ----------------- | --------------------------------------------------------------------------------------------- | ------------------------------------ |
| Cetus CLMM        | [@cetuspackages/clmm](https://www.moveregistry.com/package/@cetuspackages/clmm)               | `mvr add @cetuspackages/clmm`        |
| Cetus DCA         | [@cetuspackages/dca](https://www.moveregistry.com/package/@cetuspackages/dca)                 | `mvr add @cetuspackages/dca`         |
| Cetus Farming     | [@cetuspackages/farming](https://www.moveregistry.com/package/@cetuspackages/farming)         | `mvr add @cetuspackages/farming`     |
| Cetus Limit Order | [@cetuspackages/limit-order](https://www.moveregistry.com/package/@cetuspackages/limit-order) | `mvr add @cetuspackages/limit-order` |
| Cetus Vaults      | [@cetuspackages/vaults](https://www.moveregistry.com/package/@cetuspackages/vaults)           | `mvr add @cetuspackages/vaults`      |
| Cetus LP Burn     | [@cetuspackages/lpburn](https://www.moveregistry.com/package/@cetuspackages/lpburn)           | `mvr add @cetuspackages/lpburn`      |
| Cetus Dividends   | [@cetuspackages/dividends](https://www.moveregistry.com/package/@cetuspackages/dividends)     | `mvr add @cetuspackages/dividends`   |
| xCETUS            | [@cetuspackages/xcetus](https://www.moveregistry.com/package/@cetuspackages/xcetus)           | `mvr add @cetuspackages/xcetus`      |

**Install mvr CLI and using Move Registry CLI:**

```bash
# Add package in mainnet(e.g., Cetus CLMM)
mvr add @cetuspackages/clmm --network mainnet
```

**Benefits:**

- ✅ Automatically gets the latest published version
- ✅ No manual updates needed
- ✅ Single source of truth for addresses and versions

> **Need the published address?** Visit the Move Registry link for each contract to find the latest published addresses and versions.

### Cetus CLMM

The Cetus CLMM Interface provides comprehensive function interfaces for all core CLMM features, allowing users to seamlessly interact with the CLMM protocol. For detailed information, refer to the [CLMM README Document](./sui/cetus_clmm/README.md).

### LP Burn

The Cetus LP Burn module integrates all core LP burn interfaces from LP Burn. For detailed information, refer to the [LP Burn README Document](./sui/lp_burn/README.md).

### Stable Farming

The Cetus Stable Farming module integrates all core function interfaces for Stable Farming features. For detailed information, refer to the [Stable Farming README Document](./sui/stable_farming/README.md).

### Token

The Cetus Token Interface integrates Cetus token modules. For detailed information, refer to the [Token README Document](./sui/token/README.md).

### Limit Order

The Cetus Limit Order module seamlessly integrates all core functionalities of the Limit Order interface. For detailed information, refer to the [Limit Order README Document](./sui/limitorder/README.md).

### DCA

The Cetus DCA module integrates all core functionalities of the DCA (Dollar Cost Averaging) interface. For detailed information, refer to the [DCA README Document](./sui/dca/README.md).

### Vaults

The Cetus Vaults module integrates all core functionalities of the Vaults interface. For detailed information, refer to the [Vaults README Document](./sui/vaults/README.md).

---

**Note:** Please ensure all necessary preparations are made before any upgrade takes effect.

---

# More About Cetus

Use the following links to learn more about Cetus:

Learn more about working with Cetus in the [Cetus Documentation](https://cetus-1.gitbook.io/cetus-docs).

Join the Cetus community on [Cetus Discord](https://discord.com/channels/1009749448022315008/1009751382783447072).
