#!/bin/bash

## 修改默认登录地址
sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate


rm -rf package/new
mkdir -p package/new

## ======================== Golang 编译环境 ========================
rm -rf feeds/packages/lang/golang
git clone --depth 1 https://github.com/sbwml/packages_lang_golang -b 26.x feeds/packages/lang/golang

## ======================== 主题 ========================
## argon 主题背景
if [ -d feeds/luci/themes/luci-theme-argon ]; then
  mkdir -p feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/background
  cp -f $GITHUB_WORKSPACE/patches/bg1.jpg feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/background/bg1.jpg
  rm -rf feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg 2>/dev/null
fi
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' feeds/luci/collections/luci-light/Makefile 2>/dev/null || true

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

## ======================== DDNS ========================
rm -rf feeds/luci/applications/luci-app-ddns-go
rm -rf feeds/packages/net/ddns-go
git clone --depth 1 https://github.com/sirpdboy/luci-app-ddns-go package/new/ddnsgo
mv -n package/new/ddnsgo/*ddns-go package/new/
rm -rf package/new/ddnsgo

## ======================== 下载工具 ========================
## Alist
git clone --depth 1 https://github.com/sbwml/luci-app-alist package/new/luci-app-alist

## ======================== 工具类 ========================
## luci-app-socat
git clone --depth 1 https://github.com/chenmozhijin/luci-app-socat package/new/socat
mv -n package/new/socat/luci-app-socat package/new/
rm -rf package/new/socat

## default-settings
cp -rf $GITHUB_WORKSPACE/patches/default-settings package/new/default-settings

rm -rf package/new/openwrt-packages

## ======================== ZSH ========================
bash $GITHUB_WORKSPACE/scripts/zsh.sh

## ======================== 最终检查 ========================
echo "==== Packages in package/new/ ===="
ls -1 package/new/
