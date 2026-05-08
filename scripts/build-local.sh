#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

TARGETS=(
  "rax3000m-21.02|https://github.com/hanwckf/immortalwrt-mt798x|openwrt-21.02|immo-21.02/cmcc-rax3000m.config|immo-21.02/cmcc-rax3000m.sh"
  "rax3000m-24.10|https://github.com/immortalwrt/immortalwrt|openwrt-24.10|immo-24.10/cmcc-rax3000m.config|immo-24.10/cmcc-rax3000m.sh"
  "x86_64|https://github.com/openwrt/openwrt|openwrt-21.02|x86_64/x86_64.config|x86_64/x86_64.sh"
)

BUILD_DIR="${BUILD_DIR:-$HOME/openwrt-build}"

usage() {
  echo "Usage: $0 <target> [options]"
  echo ""
  echo "Targets:"
  echo "  rax3000m-21.02   RAX3000M NAND (hanwckf ImmortalWrt 21.02)"
  echo "  rax3000m-24.10   RAX3000M NAND (ImmortalWrt 24.10)"
  echo "  x86_64           x86_64 soft router (OpenWrt 21.02)"
  echo ""
  echo "Options:"
  echo "  --jobs N         Parallel jobs (default: nproc)"
  echo "  --build-dir DIR  Build directory (default: ~/openwrt-build)"
  echo "  --deps-only      Only install dependencies, don't build"
  echo "  --menuconfig     Run make menuconfig before building"
  echo "  --download-only  Only download packages, don't compile"
  echo ""
  echo "Examples:"
  echo "  $0 rax3000m-24.10"
  echo "  $0 x86_64 --jobs 4 --menuconfig"
  echo "  $0 rax3000m-21.02 --build-dir /data/openwrt"
  exit 1
}

install_deps() {
  echo ">>> Installing build dependencies..."
  sudo apt-get update
  sudo apt-get install -y ack antlr3 asciidoc autoconf automake autopoint \
    binutils bison build-essential bzip2 ccache clang cmake cpio curl \
    device-tree-compiler ecj fastjar flex gawk gettext gcc-multilib \
    g++-multilib git gnutls-dev gperf haveged help2man intltool lib32gcc-s1 \
    libc6-dev-i386 libelf-dev libfuse-dev libglib2.0-dev libgmp3-dev \
    libltdl-dev libmpc-dev libmpfr-dev libncurses5-dev libncursesw5-dev \
    libpython3-dev libreadline-dev libssl-dev libtool lld llvm lrzsz mkisofs \
    msmtp nano ninja-build p7zip p7zip-full patch pkgconf python3 python3-pip \
    python3-ply python3-pyelftools qemu-utils re2c rsync scons squashfs-tools \
    subversion swig texinfo uglifyjs upx-ucl unzip vim wget xmlto xxd \
    zlib1g-dev
  echo ">>> Dependencies installed."
}

find_target() {
  local name="$1"
  for t in "${TARGETS[@]}"; do
    if [[ "$t" == "$name|"* ]]; then
      echo "$t"
      return 0
    fi
  done
  return 1
}

# Parse arguments
TARGET=""
JOBS="$(nproc)"
DEPS_ONLY=false
MENUCONFIG=false
DOWNLOAD_ONLY=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --jobs) JOBS="$2"; shift 2 ;;
    --build-dir) BUILD_DIR="$2"; shift 2 ;;
    --deps-only) DEPS_ONLY=true; shift ;;
    --menuconfig) MENUCONFIG=true; shift ;;
    --download-only) DOWNLOAD_ONLY=true; shift ;;
    -h|--help) usage ;;
    -*) echo "Unknown option: $1"; usage ;;
    *) TARGET="$1"; shift ;;
  esac
done

[[ -z "$TARGET" ]] && usage

TARGET_INFO=$(find_target "$TARGET") || { echo "Error: Unknown target '$TARGET'"; usage; }

IFS='|' read -r T_NAME T_REPO T_BRANCH T_CONFIG T_DIY <<< "$TARGET_INFO"

echo "=============================================="
echo " OpenWrt Local Build"
echo "=============================================="
echo " Target:    $T_NAME"
echo " Source:    $T_REPO ($T_BRANCH)"
echo " Config:    $T_CONFIG"
echo " DIY:       $T_DIY"
echo " Build dir: $BUILD_DIR/$T_NAME"
echo " Jobs:      $JOBS"
echo "=============================================="

# Step 1: Install dependencies
install_deps
[[ "$DEPS_ONLY" == true ]] && { echo ">>> Done (deps only)."; exit 0; }

# Step 2: Clone or update source
WORK_DIR="$BUILD_DIR/$T_NAME"
if [[ -d "$WORK_DIR/.git" ]]; then
  echo ">>> Source directory exists, pulling latest..."
  cd "$WORK_DIR"
  git pull || true
else
  echo ">>> Cloning source code..."
  mkdir -p "$BUILD_DIR"
  git clone --depth 1 "$T_REPO" -b "$T_BRANCH" "$WORK_DIR"
  cd "$WORK_DIR"
fi

# Step 3: Upgrade Go toolchain
echo ">>> Upgrading Go toolchain..."
rm -rf feeds/packages/lang/golang
git clone --depth 1 https://github.com/sbwml/packages_lang_golang -b 26.x feeds/packages/lang/golang

# Step 4: Update feeds
echo ">>> Updating feeds..."
./scripts/feeds update -a
./scripts/feeds install -a

# Step 5: Apply config and run DIY script
echo ">>> Applying configuration..."
export GITHUB_WORKSPACE="$PROJECT_DIR"

[[ -e "$PROJECT_DIR/files" ]] && cp -r "$PROJECT_DIR/files" files/
cp "$PROJECT_DIR/$T_CONFIG" .config
chmod +x "$PROJECT_DIR/$T_DIY"
bash "$PROJECT_DIR/$T_DIY"

# Step 6: Make defconfig
echo ">>> Running make defconfig..."
make defconfig

# Step 7: Optional menuconfig
[[ "$MENUCONFIG" == true ]] && make menuconfig

# Step 8: Download packages
echo ">>> Downloading packages..."
make download -j8 V=10
find dl -size -1024c -exec rm -f {} \;

[[ "$DOWNLOAD_ONLY" == true ]] && { echo ">>> Done (download only)."; exit 0; }

# Step 9: Compile
echo ">>> Compiling with $JOBS jobs..."
echo ">>> Started at: $(date)"
make -j"$JOBS" || {
  echo ">>> Parallel build failed, retrying with -j1 V=s for error details..."
  make -j1 V=s
}
echo ">>> Finished at: $(date)"

# Step 10: Show output
echo ""
echo "=============================================="
echo " Build complete!"
echo "=============================================="
echo " Firmware location:"
ls bin/targets/*/*/ 2>/dev/null | head -20
echo ""
echo " Full output directory:"
echo " $WORK_DIR/bin/targets/"
