#!/bin/bash

# ------------------------------- Main source started -------------------------------

# Modify default language
sed -i "s/zh_cn/en/g" feeds/luci/modules/luci-base/root/etc/uci-defaults/luci-base
sed -i "s/zh_cn/en/g" package/lean/default-settings/files/zzz-default-settings

# Modify default timezone
sed -i "s/CST-8/WIB-7/g" package/lean/default-settings/files/zzz-default-settings
sed -i "s/Shanghai/Jakarta/g" package/lean/default-settings/files/zzz-default-settings

# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
sed -i 's/luci-theme-bootstrap/luci-theme-material/g' ./feeds/luci/collections/luci/Makefile

# Add autocore support for armvirt
sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armvirt/g' package/lean/autocore/Makefile

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/lean/default-settings/files/zzz-default-settings
echo "DISTRIB_SOURCECODE='Homemade'" >>package/base-files/files/etc/openwrt_release

# Modify default Hostname
sed -i 's/OpenWrt/ANDRRA/g' package/base-files/files/bin/config_generate

# Modify default NTP Server
sed -i 's/ntp.aliyun.com/0.openwrt.pool.ntp.org/g' package/base-files/files/bin/config_generate
sed -i 's/time1.cloud.tencent.com/1.openwrt.pool.ntp.org/g' package/base-files/files/bin/config_generate
sed -i 's/time.ustc.edu.cn/2.openwrt.pool.ntp.org/g' package/base-files/files/bin/config_generate
sed -i 's/cn.pool.ntp.org/3.openwrt.pool.ntp.org/g' package/base-files/files/bin/config_generate

# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------

# Add luci-app-openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app/openclash
pushd package/luci-app/openclash/tools/po2lmo && make && sudo make install 2>/dev/null && popd

# Entering openclash core directory
mkdir -p package/base-files/files/etc/openclash/core/
cd package/base-files/files/etc/openclash/core/

# Cloning OpenCLash Repo
git clone https://github.com/vernesong/OpenClash --depth=1
mv OpenClash/core-lateset/dev/clash-linux-armv8.tar.gz clash.tar.gz
mv OpenClash/core-lateset/premium/clash-linux-armv8-2022.01.27.gz clash_tun.gz
rm -rf OpenClash

# Make OpenClash Core executable
tar zxvf clash.tar.gz
gunzip -d clash_tun.gz
rm clash.tar.gz
chmod 755 clash*

# ------------------------------- Other ends -------------------------------

