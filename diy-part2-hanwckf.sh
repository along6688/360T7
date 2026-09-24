#!/usr/bin/env bash
# diy-part2：在 ./scripts/feeds install -a 之后、make defconfig 之前运行
# 工作目录：immortalwrt 源码根目录
set -e

echo "==> [diy-part2] 选定插件"

cat >> .config <<'EOF'

# ===== 360T7 闭源 WiFi 构建 - 用户指定插件 =====
# 硬件加速（MTK 专用变体，兼容闭源 mtwifi 驱动）
CONFIG_PACKAGE_luci-app-turboacc-mtk=y
# 网速控制（MTK 专用变体）
CONFIG_PACKAGE_luci-app-eqos-mtk=y

# 科学上网 Passwall（来自 Openwrt-Passwall feed）
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_xray-core=y
CONFIG_PACKAGE_sing-box=y
CONFIG_PACKAGE_chinadns-ng=y

# 应用过滤 OpenAppFilter（包名 luci-app-oaf）
CONFIG_PACKAGE_luci-app-oaf=y
CONFIG_PACKAGE_oaf=y
CONFIG_PACKAGE_open-app-filter=y
CONFIG_PACKAGE_luci-i18n-oaf-zh-cn=y

# 域名解析 SmartDNS（默认 feeds 已含）
CONFIG_PACKAGE_smartdns=y
CONFIG_PACKAGE_luci-app-smartdns=y

# 主题 design
CONFIG_PACKAGE_luci-theme-design=y
CONFIG_PACKAGE_luci-app-design-config=y

# IPv6 支撑（底包通常已开 CONFIG_IPV6）
CONFIG_PACKAGE_luci-proto-ipv6=y
CONFIG_PACKAGE_odhcp6c=y
CONFIG_PACKAGE_odhcpd-ipv6only=y
CONFIG_PACKAGE_kmod-ipt-nat6=y

# 中文界面
CONFIG_LUCI_LANG_zh_Hans=y
EOF

# 首次启动将默认主题设为 design（若主题存在）
mkdir -p files/etc/uci-defaults
cat > files/etc/uci-defaults/zzz-default-theme <<'UCI'
#!/bin/sh
if [ -d /www/luci-static/design ]; then
    uci set luci.main.mediaurlbase='/luci-static/design'
    uci commit luci
fi
exit 0
UCI

echo "==> [diy-part2] 完成"
