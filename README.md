# build-openwrt

[![rax3000m-immo](https://img.shields.io/github/actions/workflow/status/0x032c/build-openwrt/build-rax3000m-immo.yml?style=flat&logo=github&label=rax3000m-immo)](https://github.com/0x032c/build-openwrt/actions/workflows/build-rax3000m-immo.yml)
[![x86_64-main](https://img.shields.io/github/actions/workflow/status/0x032c/build-openwrt/build-x86_64-main.yml?style=flat&logo=github&label=x86_64-main)](https://github.com/0x032c/build-openwrt/actions/workflows/build-x86_64-main.yml)
[![LICENSE](https://img.shields.io/github/license/0x032c/build-openwrt?style=flat)](https://github.com/0x032c/build-openwrt/blob/main/LICENSE)

使用 GitHub Actions 自动构建 OpenWrt / ImmortalWrt 固件。

## 支持设备

| 设备 | 源码 | 架构 | Workflow |
|------|------|------|----------|
| CMCC RAX3000M (NAND) | [hanwckf/immortalwrt-mt798x](https://github.com/hanwckf/immortalwrt-mt798x) | MT7981 (arm64) | `build-rax3000m-immo.yml` |
| x86_64 软路由/虚拟机 | [openwrt/openwrt](https://github.com/openwrt/openwrt) | x86_64 | `build-x86_64-main.yml` |

## 固件特性

- 默认后台地址：`192.168.100.1`
- 默认密码：`password`
- 主题：Argon
- 终端：ZSH + Oh My Zsh

### 预装插件

| 类别 | 插件 |
|------|------|
| 科学上网 | OpenClash, Passwall (x86) |
| DNS | MosDNS, AdGuardHome |
| 下载 | qBittorrent (x86), Alist (x86) |
| 工具 | DDNS-Go, Socat, WoL+, 文件助手 |

## 使用方法

1. 进入 [Actions](https://github.com/0x032c/build-openwrt/actions) 页面
2. 选择左侧对应的 workflow
3. 点击右侧 **"Run workflow"** 按钮手动触发构建
4. 等待约 1~1.5 小时，构建完成后固件会自动发布到 [Releases](https://github.com/0x032c/build-openwrt/releases)

## 项目结构

```
├── .github/workflows/     # GitHub Actions 工作流
├── immo/                  # RAX3000M 配置和 DIY 脚本
├── main/                  # x86_64 配置和 DIY 脚本
├── patches/               # 自定义补丁（AdGuardHome、default-settings、.zshrc）
├── scripts/               # 共享脚本（环境初始化、磁盘清理、OpenClash）
└── bg1.jpg                # Argon 主题背景图
```

## 致谢

- [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)
- [hanwckf/immortalwrt-mt798x](https://github.com/hanwckf/immortalwrt-mt798x)
- [OpenWrt](https://github.com/openwrt/openwrt)
