#!/usr/bin/env bash
# diy-part1：在 ./scripts/feeds update 之前运行
# 工作目录：immortalwrt 源码根目录（工作流以 working-directory: immortalwrt 调用本脚本）
set -e

echo "==> [diy-part1] 注入第三方 feed 与单包"

# 1) Passwall（Openwrt-Passwall 组织，main 分支，已验证对 21.02 可用）
#    openwrt-passwall         -> luci-app-passwall
#    openwrt-passwall-packages-> xray-core / sing-box / chinadns-ng 等依赖
cat >> feeds.conf.default <<'EOF'

# ===== 自定义 feed（360T7 闭源构建）=====
src-git passwall https://github.com/Openwrt-Passwall/openwrt-passwall.git;main
src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main
EOF

# 2) 直接克隆单包到 package/（避免 feed 分支与 21.02 不兼容）
#    theme-design：gngpp 原版，支持 OpenWrt 21.x 的 js 主题
git clone --depth=1 https://github.com/gngpp/luci-theme-design.git package/luci-theme-design

#    OpenAppFilter：destan19 原版，提供 luci-app-oaf / oaf(kmod) / open-app-filter
#    （即用户之前说的 luci-app-appfilter 的等价实现，功能完全一致）
git clone --depth=1 https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter

echo "==> [diy-part1] 完成"
