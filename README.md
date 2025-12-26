# Cetus clmm interface

<a name="readme-top"></a>
![GitHub Repo stars](https://img.shields.io/github/stars/CetusProtocol/cetus-clmm-interface?logo=github)

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <h3 align="center">Cetus-CLMM-INTERFACE</h3>

  <p align="center">
    Integrating Cetus-CLMMPOOL: A Comprehensive Guide
    <br />
    <a href="https://cetus-1.gitbook.io/cetus-docs/"><strong>Explore the docs »</strong></a>
<br />
    <br />
    ·
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

| Contract | Move Registry Package | Integration |
|----------|---------------------|-------------|
| Cetus CLMM | [@cetuspackages/clmm](https://www.moveregistry.com/package/@cetuspackages/clmm) | `mvr add @cetuspackages/clmm` |
| Cetus DCA | [@cetuspackages/dca](https://www.moveregistry.com/package/@cetuspackages/dca) | `mvr add @cetuspackages/dca` |
| Cetus Farming | [@cetuspackages/farming](https://www.moveregistry.com/package/@cetuspackages/farming) | `mvr add @cetuspackages/farming` |
| Cetus Limit Order | [@cetuspackages/limit-order](https://www.moveregistry.com/package/@cetuspackages/limit-order) | `mvr add @cetuspackages/limit-order` |
| Cetus Vaults | [@cetuspackages/vaults](https://www.moveregistry.com/package/@cetuspackages/vaults) | `mvr add @cetuspackages/vaults` |
| Cetus LP Burn | [@cetuspackages/lpburn](https://www.moveregistry.com/package/@cetuspackages/lpburn) | `mvr add @cetuspackages/lpburn` |
| Cetus Dividends | [@cetuspackages/dividends](https://www.moveregistry.com/package/@cetuspackages/dividends) | `mvr add @cetuspackages/dividends` |
| xCETUS | [@cetuspackages/xcetus](https://www.moveregistry.com/package/@cetuspackages/xcetus) | `mvr add @cetuspackages/xcetus` |

**Using Move Registry CLI:**

```bash
# Install mvr CLI
npm install -g @mvr/mvr

# Add package (e.g., Cetus CLMM)
mvr add @cetuspackages/clmm

# Use in your Move.toml
CetusClmm = { registry = "@cetuspackages/clmm" }
```

**Benefits:**
- ✅ Automatically gets the latest published version
- ✅ No manual updates needed
- ✅ Single source of truth for addresses and versions

> **Need the published address?** Visit the Move Registry link for each contract to find the latest published addresses and versions.

### Cetus CLMM

The Cetus CLMM Interface provider all core features function interface of CLMM, allowing users to easily connect with CLMM by contract. For more detailed information, please refer to the CLMM README document. [CLMM README Document](./sui/cetus_clmm/README.md)

### LP Burn

The Cetus LP Burn integrate all core lp burn interface of Stable Farming, For more detailed information, please refer to the LP Burn README document. [LP Burn README Document](./sui/lp_burn/README.md)

### Stable Farming

The Cetus Stable Farming integrate all core features function interface of Stable Farming, For more detailed information, please refer to the Stable Farming README document. [Stable Farming README Document](./sui/stable_farming/README.md)

### Token

The Cetus Token Interface integrates cetus, xcetus, dividends. For more detailed information, please refer to the Token README document. [Token README Document](./sui/token/README.md)

### Limit Order

The Cetus Limit Order seamlessly integrates all core functionalities of the Limit Order interface. For more detailed information, please refer to the Limit Order README document. [Limit Order README Document](./sui/limitorder/README.md)

### DCA

The Cetus DCA integrates all core functionalities of the DCA interface. For more detailed information, please refer to the DCA README document. [DCA README Document](./sui/dca/README.md)

### Vaults

The Cetus vaults integrates all core functionalities of the vaults interface. For more detailed information, please refer to the Vaults README document. [Vaults README Document](./sui/vaults/README.md)

Please ensure all necessary preparations are made before the upgrade takes effect.

---

# More About Cetus

Use the following links to learn more about Cetus:

Learn more about working with Cetus in the [Cetus Documentation](https://cetus-1.gitbook.io/cetus-docs).

Join the Cetus community on [Cetus Discord](https://discord.com/channels/1009749448022315008/1009751382783447072).
