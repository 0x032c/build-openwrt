# Virtual Machine Deployment Guide

Deploy ImmortalWrt x86_64 firmware in VMware, Proxmox, VirtualBox, or Hyper-V.

## Download

Go to [Releases](https://github.com/0x032c/build-openwrt/releases) and download the appropriate format:

| Format | Platform |
|--------|----------|
| `.vmdk` | VMware Workstation / ESXi |
| `.qcow2` | Proxmox VE / QEMU |
| `.vdi` | VirtualBox |
| `.vhdx` | Hyper-V |
| `.iso` | CD boot install |
| `.img.gz` | dd write to disk |

## VMware Workstation Setup

1. **New Virtual Machine** → Custom → Linux → Other Linux 5.x kernel 64-bit
2. Memory: 512MB+ (recommended 1GB)
3. CPU: 1-2 cores
4. **Remove default hard disk** → Add → Hard Disk → Use an existing virtual disk → select `.vmdk`
5. Network adapters:
   - **Network Adapter 1** (LAN) → Host-only
   - **Network Adapter 2** (WAN) → NAT or Bridged
6. Both adapters → Advanced → Adapter Type: **VMXNET 3** (avoid e1000 Tx Hang issue)
7. Make sure **"Connected"** checkbox is checked for both adapters

## First Boot

After booting, you'll see the OpenWrt shell. The default LAN IP is `192.168.100.1`.

## Change LAN IP

If your host's virtual network (e.g. VMnet1) is on a different subnet, you need to change the LAN IP to match.

Check your host's VMnet IP first (Windows: `ipconfig`, Linux: `ip addr`), then adjust:

```bash
# Example: set LAN IP to 192.168.100.2
uci set network.lan.ipaddr='192.168.100.2'
uci commit network
/etc/init.d/network restart
```

## Verify Connectivity

From your host machine:

```bash
ping 192.168.100.2
```

If ping succeeds, open browser: `http://192.168.100.2`

## Troubleshooting

### Can't ping the VM

1. Check VMware adapter is set to **Host-only** and **Connected**
2. Verify host and VM are on the same subnet
3. Temporarily disable host firewall to test

### "Detected Tx Unit Hang" flooding console

Change VMware network adapter type from E1000 to **VMXNET 3** in VM settings → Network Adapter → Advanced.

### Web UI not loading

```bash
# Check if uhttpd is running
/etc/init.d/uhttpd status

# Start it if stopped
/etc/init.d/uhttpd start
```

### Set a root password

```bash
passwd
```

## Proxmox VE Setup

```bash
# Upload qcow2 to Proxmox storage
qm importdisk <vmid> immortalwrt-*-combined-efi.qcow2 local-lvm

# Then attach the disk in Proxmox web UI
# Set boot order to the imported disk
# Add two network bridges (vmbr0 for LAN, vmbr1 for WAN)
```

## VirtualBox Setup

1. New → Linux → Other Linux (64-bit)
2. Memory: 512MB, CPU: 1
3. Do not create a virtual hard disk
4. After creation: Settings → Storage → Add `.vdi` as SATA disk
5. Network: Adapter 1 = Host-only, Adapter 2 = NAT
6. Boot the VM
