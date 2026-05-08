# Local Build Guide

Build OpenWrt/ImmortalWrt firmware locally on your own machine.

## Requirements

| Resource | Minimum | Recommended |
|----------|---------|-------------|
| CPU | 4 cores | 8+ cores |
| RAM | 8 GB (use `-j4`) | 16 GB+ |
| Disk | 60 GB per target | SSD strongly recommended |
| OS | Ubuntu 22.04 / 24.04 | Any Debian-based Linux |

> **Warning**: Do NOT build as root. OpenWrt's build system will refuse to run.

## Quick Start (One-liner)

```bash
git clone https://github.com/0x032c/build-openwrt.git
cd build-openwrt
./scripts/build-local.sh rax3000m-24.10
```

## Available Targets

| Target | Device | Source | Branch |
|--------|--------|--------|--------|
| `rax3000m-21.02` | CMCC RAX3000M (NAND) | hanwckf/immortalwrt-mt798x | openwrt-21.02 |
| `rax3000m-24.10` | CMCC RAX3000M (NAND) | immortalwrt/immortalwrt | openwrt-24.10 |
| `x86_64` | x86_64 VM / Soft Router | openwrt/openwrt | openwrt-21.02 |

## Script Options

```bash
./scripts/build-local.sh <target> [options]

Options:
  --jobs N          Parallel jobs (default: nproc)
  --build-dir DIR   Build directory (default: ~/openwrt-build)
  --deps-only       Only install dependencies
  --menuconfig      Run make menuconfig before building
  --download-only   Download packages only, skip compilation
```

### Examples

```bash
# Build RAX3000M 24.10 with default settings
./scripts/build-local.sh rax3000m-24.10

# Build x86_64 with 4 jobs and custom build directory
./scripts/build-local.sh x86_64 --jobs 4 --build-dir /data/openwrt

# Install dependencies only (useful for setting up a new machine)
./scripts/build-local.sh rax3000m-24.10 --deps-only

# Customize packages before building
./scripts/build-local.sh rax3000m-24.10 --menuconfig
```

## Manual Build Steps

If you prefer to run each step manually:

```bash
# 1. Install dependencies
sudo apt-get update
sudo apt-get install -y ack antlr3 asciidoc autoconf automake autopoint \
  binutils bison build-essential bzip2 ccache clang cmake cpio curl \
  device-tree-compiler flex gawk gettext gcc-multilib g++-multilib git \
  gnutls-dev gperf help2man intltool lib32gcc-s1 libc6-dev-i386 libelf-dev \
  libfuse-dev libglib2.0-dev libgmp3-dev libltdl-dev libmpc-dev libmpfr-dev \
  libncurses5-dev libncursesw5-dev libpython3-dev libreadline-dev libssl-dev \
  libtool lld llvm mkisofs ninja-build p7zip p7zip-full patch pkgconf \
  python3 python3-pip python3-ply python3-pyelftools qemu-utils re2c rsync \
  scons squashfs-tools subversion swig texinfo unzip vim wget xmlto xxd \
  zlib1g-dev

# 2. Clone firmware source
git clone --depth 1 https://github.com/immortalwrt/immortalwrt -b openwrt-24.10 ~/openwrt
cd ~/openwrt

# 3. Upgrade Go toolchain (required by ddns-go, mosdns, etc.)
rm -rf feeds/packages/lang/golang
git clone --depth 1 https://github.com/sbwml/packages_lang_golang -b 26.x feeds/packages/lang/golang

# 4. Update and install feeds
./scripts/feeds update -a
./scripts/feeds install -a

# 5. Apply configuration and DIY script
export GITHUB_WORKSPACE=/path/to/build-openwrt
cp $GITHUB_WORKSPACE/immo-24.10/cmcc-rax3000m.config .config
bash $GITHUB_WORKSPACE/immo-24.10/cmcc-rax3000m.sh

# 6. Generate full config
make defconfig

# 7. (Optional) Customize packages interactively
make menuconfig

# 8. Download source packages
make download -j8 V=10

# 9. Compile
make -j$(nproc) V=s 2>&1 | tee build.log

# 10. Find firmware
ls bin/targets/mediatek/filogic/
```

## Output Location

After a successful build, firmware files are at:

| Target | Output Path |
|--------|-------------|
| rax3000m-21.02 | `bin/targets/mediatek/mt7981/` |
| rax3000m-24.10 | `bin/targets/mediatek/filogic/` |
| x86_64 | `bin/targets/x86/64/` |

## Tips

- **First build is slow** (1-3 hours). Subsequent builds with ccache take 20-40 minutes.
- **If build fails**, re-run with `make -j1 V=s` to see the exact error.
- **Low on RAM?** Reduce parallelism: `--jobs 2` or `--jobs 4`.
- **Want to add more swap?**
  ```bash
  sudo fallocate -l 8G /swapfile
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
  sudo swapon /swapfile
  ```
- **Clean build** (start fresh): `make clean` or `make dirclean` for full reset.
- **Incremental builds**: Just re-run `make -j$(nproc)` after modifying configs or packages.
