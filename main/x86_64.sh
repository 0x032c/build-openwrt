#!/bin/bash

## 移除 SNAPSHOT 标签
sed -i 's,-SNAPSHOT,,g' include/version.mk
sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in

## 修改默认登录地址
sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate

## 启用 irqbalance
sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config

rm -rf package/new
mkdir -p package/new

## ======================== Golang 编译环境 ========================
rm -rf feeds/packages/lang/golang
git clone --depth 1 https://github.com/sbwml/packages_lang_golang -b 26.x feeds/packages/lang/golang

## ======================== default-settings ========================
cp -rf $GITHUB_WORKSPACE/patches/default-settings package/new/default-settings

## ======================== 主题 ========================
git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon.git package/new/luci-theme-argon
git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config.git package/new/luci-app-argon-config
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' ./feeds/luci/collections/luci-light/Makefile
rm -rf package/new/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
cp -f $GITHUB_WORKSPACE/bg1.jpg package/new/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

## ======================== 科学上网 ========================
## Passwall
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall package/new/openwrt-passwall
mv -n package/new/openwrt-passwall/luci-app-passwall package/new/
rm -rf package/new/openwrt-passwall
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall-packages package/new/passwall

## OpenClash
bash $GITHUB_WORKSPACE/scripts/openclash.sh amd64

## ======================== DNS 相关 ========================
## MosDNS
rm -rf feeds/packages/net/v2ray-geodata
git clone --depth 1 https://github.com/sbwml/luci-app-mosdns -b v5 package/new/luci-app-mosdns
git clone --depth 1 https://github.com/sbwml/v2ray-geodata package/new/v2ray-geodata

## AdGuardHome
git clone --depth 1 https://github.com/kiddin9/kwrt-packages package/new/openwrt-packages
mv package/new/openwrt-packages/luci-app-adguardhome package/new/luci-app-adguardhome
rm -rf package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml
cp -rf $GITHUB_WORKSPACE/patches/AdGuardHome/AdGuardHome_template.yaml package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml
rm -rf package/new/luci-app-adguardhome/Makefile
cp -rf $GITHUB_WORKSPACE/patches/AdGuardHome/Makefile package/new/luci-app-adguardhome/Makefile

## ======================== 下载工具 ========================
## Alist
git clone --depth 1 https://github.com/sbwml/luci-app-alist package/new/luci-app-alist

## qBittorrent
mv package/new/openwrt-packages/qBittorrent-Enhanced-Edition package/new/qBittorrent-Enhanced-Edition
mv package/new/openwrt-packages/luci-app-qbittorrent package/new/luci-app-qbittorrent
mv package/new/openwrt-packages/qt6tools package/new/qt6tools
mv package/new/openwrt-packages/qt6base package/new/qt6base
mv package/new/openwrt-packages/libdouble-conversion package/new/libdouble-conversion
rm -rf feeds/packages/libs/libtorrent-rasterbar
mv package/new/openwrt-packages/libtorrent-rasterbar package/new/libtorrent-rasterbar

## ======================== DDNS ========================
rm -rf feeds/luci/applications/luci-app-ddns-go
rm -rf feeds/packages/net/ddns-go
git clone --depth 1 https://github.com/sirpdboy/luci-app-ddns-go package/new/ddnsgo
mv -n package/new/ddnsgo/*ddns-go package/new/
rm -rf package/new/ddnsgo

## ======================== 工具类 ========================
## luci-app-wechatpush
git clone --depth 1 https://github.com/tty228/luci-app-wechatpush package/new/luci-app-wechatpush

## luci-app-socat
git clone --depth 1 https://github.com/chenmozhijin/luci-app-socat package/new/socat
mv -n package/new/socat/luci-app-socat package/new/
rm -rf package/new/socat

## luci-app-accesscontrol
mv package/new/openwrt-packages/luci-app-accesscontrol package/new/luci-app-accesscontrol

## luci-app-autoreboot
mv package/new/openwrt-packages/luci-app-autoreboot package/new/luci-app-autoreboot

## luci-app-wolplus
mv package/new/openwrt-packages/luci-app-wolplus package/new/luci-app-wolplus

## luci-app-guest-wifi
mv package/new/openwrt-packages/luci-app-guest-wifi package/new/luci-app-guest-wifi

## luci-app-irqbalance
mv package/new/openwrt-packages/luci-app-irqbalance package/new/luci-app-irqbalance

## luci-app-fileassistant & filetransfer
mv package/new/openwrt-packages/luci-app-fileassistant package/new/luci-app-fileassistant
mv package/new/openwrt-packages/luci-app-filetransfer package/new/luci-app-filetransfer
mv package/new/openwrt-packages/luci-lib-fs package/new/luci-lib-fs

## luci-app-cpufreq
mv package/new/openwrt-packages/luci-app-cpufreq package/new/luci-app-cpufreq
sed -i 's/1512000/1200000/g' package/new/luci-app-cpufreq/root/etc/uci-defaults/10-cpufreq

## luci-app-ramfree
mv package/new/openwrt-packages/luci-app-ramfree package/new/luci-app-ramfree

## autocore & automount
mv package/new/openwrt-packages/autocore package/new/autocore
mv package/new/openwrt-packages/automount package/new/automount
mv package/new/openwrt-packages/ntfs3-mount package/new/ntfs3-mount

rm -rf package/new/openwrt-packages

## ======================== TurboACC ========================
curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh

## ======================== ZSH ========================
bash $GITHUB_WORKSPACE/scripts/zsh.sh

## ======================== 最终检查 ========================
echo "==== Packages in package/new/ ===="
ls -1 package/new/
