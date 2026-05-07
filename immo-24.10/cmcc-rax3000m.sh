#!/bin/bash

## 修改默认登录地址
sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate

## 修改默认主机名
sed -i 's/ImmortalWrt/RAX3000M/g' package/base-files/files/bin/config_generate

rm -rf package/new
mkdir -p package/new

## ======================== 主题 ========================
## argon 主题背景
if [ -d feeds/luci/themes/luci-theme-argon ]; then
  rm -rf feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
  cp -f $GITHUB_WORKSPACE/bg1.jpg feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
fi
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' feeds/luci/collections/luci-light/Makefile 2>/dev/null || true

## ======================== 科学上网 ========================
## OpenClash
bash $GITHUB_WORKSPACE/scripts/openclash.sh arm64

## ======================== DDNS ========================
rm -rf feeds/luci/applications/luci-app-ddns-go
rm -rf feeds/packages/net/ddns-go
git clone --depth 1 https://github.com/sirpdboy/luci-app-ddns-go package/new/ddnsgo
mv -n package/new/ddnsgo/*ddns-go package/new/
rm -rf package/new/ddnsgo

## ======================== ZSH ========================
bash $GITHUB_WORKSPACE/scripts/zsh.sh

## ======================== 最终检查 ========================
echo "==== Packages in package/new/ ===="
ls -1 package/new/
