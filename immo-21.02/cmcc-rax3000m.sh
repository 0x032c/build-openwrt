#!/bin/bash

## 移除 SNAPSHOT 标签
sed -i 's,SNAPSHOT,,g' include/version.mk
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

## ======================== 主题 ========================
## argon 主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' ./feeds/luci/collections/luci-light/Makefile
## 替换 argon 背景图
rm -rf feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
cp -f $GITHUB_WORKSPACE/patches/bg1.jpg feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

## ======================== 科学上网 ========================
## OpenClash
bash $GITHUB_WORKSPACE/scripts/openclash.sh arm64

## ======================== DNS 相关 ========================
## MosDNS
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/packages/net/mosdns
git clone --depth 1 https://github.com/sbwml/v2ray-geodata package/new/v2ray-geodata
git clone --depth 1 https://github.com/sbwml/luci-app-mosdns -b v5 package/new/sbwml-mosdns
mv -n package/new/sbwml-mosdns/*mosdns package/new/
mv -n package/new/sbwml-mosdns/v2dat package/new/
rm -rf package/new/sbwml-mosdns

## AdGuardHome
git clone --depth 1 -b patch-1 https://github.com/kiddin9/openwrt-adguardhome package/new/openwrt-adguardhome
mv package/new/openwrt-adguardhome/*adguardhome package/new/
rm -rf package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml
cp -rf $GITHUB_WORKSPACE/patches/AdGuardHome/AdGuardHome_template.yaml package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml
rm -rf package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/links.txt
cp -rf $GITHUB_WORKSPACE/patches/AdGuardHome/links.txt package/new/luci-app-adguardhome/root/usr/share/AdGuardHome/links.txt
rm -rf package/new/openwrt-adguardhome

## ======================== DDNS ========================
rm -rf feeds/luci/applications/luci-app-ddns-go
rm -rf feeds/packages/net/ddns-go
git clone --depth 1 https://github.com/sirpdboy/luci-app-ddns-go package/new/ddnsgo
mv -n package/new/ddnsgo/*ddns-go package/new/
rm -rf package/new/ddnsgo

## ======================== 工具类 ========================
## socat
rm -rf feeds/packages/net/socat
git clone --depth 1 https://github.com/immortalwrt/packages package/new/immortalwrt-packages
mv package/new/immortalwrt-packages/net/socat package/new/socat
rm -rf package/new/immortalwrt-packages
rm -rf feeds/luci/applications/luci-app-socat
git clone --depth 1 https://github.com/chenmozhijin/luci-app-socat package/new/chenmozhijin-socat
mv -n package/new/chenmozhijin-socat/luci-app-socat package/new/
rm -rf package/new/chenmozhijin-socat

## ======================== kiddin9 包 ========================
git clone --depth 1 https://github.com/kiddin9/kwrt-packages package/new/openwrt-packages

## luci-app-autoreboot
mv package/new/openwrt-packages/luci-app-autoreboot package/new/luci-app-autoreboot

## luci-app-wolplus
mv package/new/openwrt-packages/luci-app-wolplus package/new/luci-app-wolplus

## luci-app-fileassistant
rm -rf feeds/luci/applications/luci-app-fileassistant
mv package/new/openwrt-packages/luci-app-fileassistant package/new/luci-app-fileassistant

rm -rf package/new/openwrt-packages

## ======================== ZSH ========================
bash $GITHUB_WORKSPACE/scripts/zsh.sh

## ======================== 最终检查 ========================
echo "==== Packages in package/new/ ===="
ls -1 package/new/
