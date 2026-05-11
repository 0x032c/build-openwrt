# build-openwrt

[![rax3000m-21.02](https://img.shields.io/github/actions/workflow/status/0x032c/build-openwrt/build-rax3000m-21.02.yml?style=flat&logo=github&label=rax3000m-21.02)](https://github.com/0x032c/build-openwrt/actions/workflows/build-rax3000m-21.02.yml)
[![rax3000m-24.10](https://img.shields.io/github/actions/workflow/status/0x032c/build-openwrt/build-rax3000m-24.10.yml?style=flat&logo=github&label=rax3000m-24.10)](https://github.com/0x032c/build-openwrt/actions/workflows/build-rax3000m-24.10.yml)
[![x86_64-main](https://img.shields.io/github/actions/workflow/status/0x032c/build-openwrt/build-x86_64-main.yml?style=flat&logo=github&label=x86_64-main)](https://github.com/0x032c/build-openwrt/actions/workflows/build-x86_64-main.yml)
[![LICENSE](https://img.shields.io/github/license/0x032c/build-openwrt?style=flat)](https://github.com/0x032c/build-openwrt/blob/main/LICENSE)

Custom ImmortalWrt firmware builds via GitHub Actions — based on official sources, pre-configured with commonly used packages, themes, and sensible defaults. Flash and go, no manual setup needed.

## Supported Devices

| Device | Source | Kernel | WiFi | Workflow |
|--------|--------|--------|------|----------|
| RAX3000M (NAND) - Legacy | [hanwckf/immortalwrt-mt798x](https://github.com/hanwckf/immortalwrt-mt798x) | 5.4 | MTK closed-source | `build-rax3000m-21.02.yml` |
| RAX3000M (NAND) - **24.10** | [immortalwrt/immortalwrt](https://github.com/immortalwrt/immortalwrt) | 6.6 | mt76 open-source | `build-rax3000m-24.10.yml` |
| x86_64 (VM / Soft Router) | [immortalwrt/immortalwrt](https://github.com/immortalwrt/immortalwrt) | 6.6 | N/A | `build-x86_64-main.yml` |

## What's different from official images?

| | Official ImmortalWrt | This build |
|--|---------------------|------------|
| Theme | Bootstrap (basic) | Argon + custom background |
| Shell | ash | ZSH + Oh My Zsh |
| LAN IP | 192.168.1.1 | 192.168.100.1 |
| Language | English | Chinese (zh-cn) |
| NTP | Global servers | China servers (aliyun, tencent) |
| DNS | 223.5.5.5, 8.8.8.8 | Fixed on WAN |
| Password | None | None |
| x86 NIC drivers | Basic (e1000) | e1000e, igb, igc, i40e, ixgbe, r8169, vmxnet3 |
| x86 formats | img only | img, vmdk, qcow2, vdi, vhdx, iso |

## Pre-installed Packages

| Category | Packages |
|----------|----------|
| Proxy | Passwall (x86), OpenClash |
| DNS | MosDNS, AdGuardHome, SmartDNS |
| VPN | WireGuard, ZeroTier, frpc (frp client) |
| DDNS | DDNS-Go |
| Download | Alist |
| File sharing | Samba4, FileBrowser |
| Monitoring | nlbwmon (bandwidth), vnstat2 (traffic stats) |
| Network | UPnP, WoL (Wake on LAN), Socat |
| System | ttyd (web terminal), Watchcat (auto-reboot on failure), AutoReboot (scheduled) |
| Certificates | ACME (auto SSL)

## Releases

All firmware images are published under a unified tag: **`v24.10-rN`** (e.g. `v24.10-r1`, `v24.10-r2`...).

Each release contains firmware for all supported devices. The version number auto-increments on every build.

> Download the latest release: [Releases](../../releases)

## Quick Start

1. Click **[Fork](https://github.com/0x032c/build-openwrt/fork)** at the top right
2. In your forked repo, go to **Actions** tab → Click **"I understand my workflows, go ahead and enable them"**
3. Select **build-all** to build all targets, or choose a specific device workflow
4. Click **"Run workflow"** → Wait ~1–1.5 hours
5. Firmware will be published to your repo's [Releases](../../releases) automatically

> **Scheduled builds**: `build-all` runs automatically on the 1st of each month.

## Local Build

You can also build firmware locally on any Linux machine (16GB+ RAM recommended):

```bash
git clone https://github.com/0x032c/build-openwrt.git
cd build-openwrt
./scripts/build-local.sh rax3000m-24.10
```

See [docs/LOCAL_BUILD.md](docs/LOCAL_BUILD.md) for full instructions, options, and manual steps.

## Project Structure

```
├── .github/workflows/     # CI workflow definitions (build-all, per-device, delete-tags)
├── immo-21.02/            # RAX3000M (hanwckf 21.02) config & DIY script
├── immo-24.10/            # RAX3000M (ImmortalWrt 24.10) config & DIY script
├── x86_64/                # x86_64 device config & DIY script
├── uboot/                 # Pre-built U-Boot for RAX3000M (supports .itb)
├── patches/               # Custom patches (AdGuardHome, default-settings, bg1.jpg, .zshrc)
├── scripts/               # Shared scripts (env setup, disk cleanup, OpenClash, local build)
├── docs/                  # Documentation (local build guide)
├── COMPARISON.md          # Detailed comparison: 21.02 vs 24.10
└── LICENSE
```

## Credits

- [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)
- [hanwckf/immortalwrt-mt798x](https://github.com/hanwckf/immortalwrt-mt798x)
- [OpenWrt](https://github.com/openwrt/openwrt)
