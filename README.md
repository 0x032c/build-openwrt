# AutoBuild-OpenWrt
[![Build Status](https://img.shields.io/github/actions/workflow/status/0x032c/build-openwrt/x86_64-main.yml?style=flat&logo=github)](https://github.com/0x032c/build-openwrt/actions/workflows/x86_64-main.yml)
[![LICENSE](https://img.shields.io/github/license/mashape/apistatus.svg?style=flat&logo=github&label=LICENSE)](https://github.com/0x032c/build-openwrt/blob/master/LICENSE)

Build OpenWrt firware [hanwckf's OpenWrt](https://github.com/hanwckf/immortalwrt-mt798x) using GitHub Actions  
Hereby thank P3TERX for his amazing job: https://github.com/P3TERX/Actions-OpenWrt/  

Hereby thank KFERMercer for his amazing job: https://github.com/KFERMercer/OpenWrt-CI  
You could edit and enable "Sync Code" YAML file to let your forked repo keep updated.

## Usage

**1. Prerequisite**
  - Sign up for [GitHub Actions](https://github.com/features/actions/signup)
  - Fork [this GitHub repository](https://github.com/0x032c/build-openwrt)
    
**2. Compile Firmware**
  - Click `[.github/workflows]` folder on the top of repo and you could see few workflow files, Each for one particular architecture(device).
  - ***`UPDATED`*** Click "Action" on the menu, click your favoriate device on the left side, then go to the right side "Run workflow" button, click and on the dropdown menu, click the green button "Run workflow", that's it!!
  - The build starts automatically. Progress can be viewed on the Actions page.
  - When the build is complete, click the `Artifacts` button in the upper right corner of the Actions page to download the binaries.
  - Default Web Admin IP: `192.168.100.1`, username `root`, password `password`

**3. Sync Code**
  - Uncomment 'push-branches-master' 3 lines under **`On`** section and commit changes to let the script sync the code once for you.
  - Uncomment 'schedule-cron' 2 lines under **`On`** section and commit changes to let the script sync the code everyday on 3 am[UTC +8]