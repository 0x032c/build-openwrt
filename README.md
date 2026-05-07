# build-openwrt

[![rax3000m-immo](https://img.shields.io/github/actions/workflow/status/0x032c/build-openwrt/build-rax3000m-immo.yml?style=flat&logo=github&label=rax3000m-immo)](https://github.com/0x032c/build-openwrt/actions/workflows/build-rax3000m-immo.yml)
[![x86_64-main](https://img.shields.io/github/actions/workflow/status/0x032c/build-openwrt/build-x86_64-main.yml?style=flat&logo=github&label=x86_64-main)](https://github.com/0x032c/build-openwrt/actions/workflows/build-x86_64-main.yml)
[![LICENSE](https://img.shields.io/github/license/0x032c/build-openwrt?style=flat)](https://github.com/0x032c/build-openwrt/blob/main/LICENSE)

Automated OpenWrt / ImmortalWrt firmware builds powered by GitHub Actions.

## Supported Devices

| Device | Source | SoC | Workflow |
|--------|--------|-----|----------|
| CMCC RAX3000M (NAND) | [hanwckf/immortalwrt-mt798x](https://github.com/hanwckf/immortalwrt-mt798x) | MT7981 (arm64) | `build-rax3000m-immo.yml` |
| x86_64 (VM / Soft Router) | [openwrt/openwrt](https://github.com/openwrt/openwrt) | x86_64 | `build-x86_64-main.yml` |

## Features

- **Theme**: Argon with custom background
- **Shell**: ZSH + Oh My Zsh (autosuggestions, syntax highlighting)
- **Default gateway**: `192.168.100.1`
- **Default password**: `password`

### Pre-installed Packages

| Category | Packages |
|----------|----------|
| Proxy | OpenClash, Passwall (x86 only) |
| DNS | MosDNS, AdGuardHome |
| Download | qBittorrent (x86), Alist (x86) |
| Utilities | DDNS-Go, Socat, WoL+, File Assistant |

## Quick Start

1. Click **[Fork](https://github.com/0x032c/build-openwrt/fork)** at the top right
2. In your forked repo, go to **Actions** tab → Click **"I understand my workflows, go ahead and enable them"**
3. Select a workflow from the left sidebar → Click **"Run workflow"**
4. Wait ~1–1.5 hours; firmware will be published to your repo's [Releases](../../releases) automatically

## Project Structure

```
├── .github/workflows/     # CI workflow definitions
├── immo/                  # RAX3000M device config & DIY script
├── main/                  # x86_64 device config & DIY script
├── patches/               # Custom patches (AdGuardHome, default-settings, .zshrc)
├── scripts/               # Shared scripts (env setup, disk cleanup, OpenClash)
└── bg1.jpg                # Argon theme background
```

## Credits

- [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)
- [hanwckf/immortalwrt-mt798x](https://github.com/hanwckf/immortalwrt-mt798x)
- [OpenWrt](https://github.com/openwrt/openwrt)
