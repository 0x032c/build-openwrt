# U-Boot for CMCC RAX3000M (NAND)

Pre-built U-Boot FIP from [hanwckf/bl-mt798x](https://github.com/hanwckf/bl-mt798x) release `20241115`.

This version supports **mainline FIT image** (`.itb` format), required for ImmortalWrt 24.10+.

## Files

| File | Description |
|------|-------------|
| `mt7981_cmcc_rax3000m-fip-fixed-parts.bin` | FIP (U-Boot) for RAX3000M NAND with fixed partition layout |

## Flash Instructions

> **WARNING: Flashing U-Boot carries brick risk. Proceed at your own risk!**

### Prerequisites

- SSH access to your router
- Currently running any OpenWrt/ImmortalWrt firmware

### Steps

1. Upload the FIP file to the router:

```bash
scp mt7981_cmcc_rax3000m-fip-fixed-parts.bin root@192.168.100.1:/tmp/
```

2. SSH into the router and flash:

```bash
# Enable MTD write access (if locked)
opkg update && opkg install kmod-mtd-rw
insmod mtd-rw i_want_a_brick=1

# Flash FIP partition
mtd unlock FIP
mtd erase FIP
mtd write /tmp/mt7981_cmcc_rax3000m-fip-fixed-parts.bin FIP

# Reboot
reboot
```

3. After reboot, the new U-Boot will support:
   - FIT image format (`.itb`) for ImmortalWrt 24.10+
   - Web UI for firmware flashing (access via `192.168.1.1` in failsafe mode)
   - Failsafe boot into initramfs

### Flashing ImmortalWrt 24.10 firmware

After U-Boot upgrade, download the firmware from [ImmortalWrt releases](https://downloads.immortalwrt.org/releases/):

1. Flash initramfs recovery image via U-Boot web UI:
   - `immortalwrt-mediatek-filogic-cmcc_rax3000m-initramfs-recovery.itb`

2. Once booted into recovery, flash sysupgrade via LuCI:
   - `immortalwrt-mediatek-filogic-cmcc_rax3000m-squashfs-sysupgrade.itb`

## Source

- Repository: https://github.com/hanwckf/bl-mt798x
- Release: https://github.com/hanwckf/bl-mt798x/releases/tag/20241115
- Build command: `SOC=mt7981 BOARD=cmcc_rax3000m ./build.sh`
