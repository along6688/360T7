#!/usr/bin/env bash
# 本地 Linux 编译 360T7（hanwckf 闭源 WiFi）
# 用法：在任意目录执行 bash /path/to/build-local-hanwckf.sh
# 要求：Ubuntu 20.04+/Debian，已安装编译依赖，且位于大小写敏感文件系统
set -e

SRC_DIR="immortalwrt-mt798x"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ ! -d "$SRC_DIR" ]; then
  echo "==> 克隆 hanwckf/immortalwrt-mt798x (openwrt-21.02)"
  git clone --depth=1 --branch openwrt-21.02 https://github.com/hanwckf/immortalwrt-mt798x.git "$SRC_DIR"
fi

cd "$SRC_DIR"

# 底包（MT7981 通用，含 360T7 设备 + 闭源 mtwifi）
cp defconfig/mt7981-ax3000.config .config

bash "$SCRIPT_DIR/diy-part1-hanwckf.sh"
./scripts/feeds update -a
./scripts/feeds install -a
bash "$SCRIPT_DIR/diy-part2-hanwckf.sh"

make defconfig
echo "==> 开始编译（使用 $(nproc) 线程）"
make -j"$(nproc)" V=s

echo "===== 固件位于 ====="
find bin/targets/mediatek/mt7981 -type f \( -iname '*360*' -o -iname '*qihoo*' \)
