# RAX3000M Firmware Comparison: 21.02 vs 24.10

## Overview

This project provides two firmware builds for CMCC RAX3000M (NAND). Choose based on your priorities.

## Side-by-Side Comparison

| | **rax3000m-21.02** | **rax3000m-24.10** |
|---|---|---|
| Source | hanwckf/immortalwrt-mt798x | immortalwrt/immortalwrt (official) |
| Base | OpenWrt 21.02 | ImmortalWrt 24.10 |
| Linux Kernel | 5.4.x | 6.6.x |
| WiFi Driver | MTK closed-source (mtwifi) | mt76 open-source |
| Package Manager | opkg (.ipk) | apk (.apk) |
| Firmware Format | .bin (legacy) | .itb (FIT image) |
| Target | mediatek/mt7981 | mediatek/filogic |
| U-Boot Required | hanwckf original | hanwckf 20241115+ (FIT support) |
| Maintenance | Inactive (last update: 2025-12) | Active (continuously updated) |
| Default Gateway | 192.168.100.1 | 192.168.100.1 |

## WiFi Performance

| | **21.02 (mtwifi)** | **24.10 (mt76)** |
|---|---|---|
| 2.4 GHz TX Power | Up to 25 dBm | ~23 dBm |
| 5 GHz TX Power | Up to 24 dBm | ~22 dBm |
| Stability | Excellent | Good (improving) |
| Features | Full MTK feature set | Standard 802.11ax |
| Driver Updates | Frozen | Community-maintained |

## Package Ecosystem

| | **21.02 (opkg)** | **24.10 (apk)** |
|---|---|---|
| Available Packages | Limited (EOL branch) | Full ImmortalWrt repo |
| Security Updates | None | Regular |
| Install from repo | Works but outdated | Latest versions |
| Kernel modules | Must match exact kernel | Must match exact kernel |

## Pre-installed Packages

| Package | 21.02 | 24.10 |
|---------|:-----:|:-----:|
| OpenClash | ✅ | ✅ |
| AdGuardHome | ✅ | ✅ |
| MosDNS | ✅ | — |
| DDNS-Go | ✅ | ✅ |
| Passwall | — | — |
| Argon Theme | ✅ | ✅ |
| ZSH + Oh My Zsh | ✅ | ✅ |
| ttyd (Web Terminal) | — | ✅ |

## Upgrade Path

```
┌─────────────────────────────────────────────────────┐
│  Currently on hanwckf 21.02 firmware?               │
│                                                     │
│  Option A: Stay on 21.02                            │
│  ─────────────────────────                          │
│  Just flash the new .bin from rax3000m-21.02        │
│  workflow via LuCI sysupgrade. No U-Boot change.    │
│                                                     │
│  Option B: Upgrade to 24.10                         │
│  ─────────────────────────                          │
│  1. Flash new U-Boot FIP (see uboot/README.md)      │
│  2. Reboot into new U-Boot web UI                   │
│  3. Flash .itb initramfs via U-Boot web             │
│  4. Flash .itb sysupgrade via LuCI                  │
│                                                     │
│  ⚠️  This is a ONE-WAY upgrade!                     │
│  Going back to 21.02 requires reflashing U-Boot     │
│  and old firmware manually.                         │
└─────────────────────────────────────────────────────┘
```

## Recommendation

| Your Priority | Recommended Build |
|---------------|-------------------|
| Best WiFi signal & range | **21.02** (MTK closed-source driver) |
| Latest security patches | **24.10** (actively maintained) |
| Modern package manager (apk) | **24.10** |
| Stability (no changes needed) | **21.02** (battle-tested) |
| Long-term support | **24.10** (will continue receiving updates) |
| Minimal risk (no U-Boot flash) | **21.02** |
| Using external AP for WiFi | **24.10** (WiFi performance doesn't matter) |

## Technical Notes

### Why two different U-Boots?

The original hanwckf U-Boot uses a legacy partition layout and only supports `.bin` firmware images. ImmortalWrt 24.10 uses FIT (Flattened Image Tree) format which requires U-Boot to understand `.itb` files. The `20241115` release of hanwckf/bl-mt798x added FIT image support (PR #80), making it compatible with both old `.bin` and new `.itb` firmware.

### Can I switch between 21.02 and 24.10?

After upgrading U-Boot to the FIT-compatible version, you can flash either format. However, switching between the two firmware versions is not a simple sysupgrade — it requires reflashing via U-Boot web UI due to different partition layouts.

### Is the mt76 driver getting better?

Yes. The open-source mt76 driver for MT7981 is under active development. Performance and stability improve with each kernel release. For most home use cases, it is already sufficient.
