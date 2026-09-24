#!/bin/bash
# ============================================================
#  build-local.sh —— 在 Ubuntu / Debian (含 WSL2) 上本地编译 360T7 固件
#  用法: bash scripts/build-local.sh [工作目录]
#        默认工作目录 ~/lede-360t7
#  资源要求: 建议 >= 8 核 / >= 8GB 内存(最好 16GB) / >= 40GB 空闲磁盘
#  耗时参考: 8 核约 1.5~2.5 小时, 4 核约 4~6 小时(首次编译)
# ============================================================
set -e

REPO_URL="https://github.com/coolsnowwolf/lede"
REPO_BRANCH="master"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORK="${1:-$HOME/lede-360t7}"

echo "==> 安装编译依赖 (需要 sudo)"
sudo apt-get update
sudo apt-get -y install build-essential clang flex bison g++ gawk \
    gcc-multilib g++-multilib gettext git libncurses5-dev libssl-dev \
    python3-setuptools rsync swig unzip zlib1g-dev file wget aria2

echo "==> 准备源码目录: $WORK"
mkdir -p "$WORK"
cd "$WORK"
if [ ! -d lede ]; then
    git clone --depth 1 -b "$REPO_BRANCH" "$REPO_URL" lede
fi
cd lede

echo "==> diy-part1 (feeds 定制)"
bash "$ROOT/scripts/diy-part1.sh"

echo "==> 更新 / 安装 feeds"
./scripts/feeds update -a
./scripts/feeds install -a

echo "==> diy-part2 (注入网速控制 + 默认设置)"
bash "$ROOT/scripts/diy-part2.sh"

echo "==> 生成 .config"
cp "$ROOT/configs/360t7.seed.config" .config
make defconfig
grep -E 'CONFIG_TARGET_mediatek_filogic_DEVICE_qihoo_360t7|CONFIG_PACKAGE_(luci-app-appfilter|appfilter|kmod-oaf|luci-app-nft-qos|nft-qos|luci-app-turboacc)=' .config || true

echo "==> 下载依赖包"
make download -j"$(nproc)" || make download -j1 V=s

echo "==> 开始编译 (首次会比较久)"
make -j"$(nproc)" || make -j1 V=s

echo "==> 完成, 产物在: $(pwd)/bin/targets/mediatek/filogic/"
ls -lh bin/targets/mediatek/filogic/ | grep -i 360t7 || true
