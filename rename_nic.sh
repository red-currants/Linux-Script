#!/usr/bin/bash
echo "当前网卡列表"
ip link show
read -p "请输入当前网卡名称 (例如: eth0, ens33): " OLD_IFNAME
read -p "请输入新的网卡名称 (例如: net0, lan0): " NEW_IFNAME

# 确认udev规则目录存在
UDEV_RULES_FILE="/etc/udev/rules.d/70-persistent-net.rules"
if [-e UDEV_RULES_FILE]; then
	echo "文件存在"
else
	echo "文件不存在，创建文件中！"
	touch  $UDEV_RULES_FILE
fi
echo "SUBSYSTEM==\"net\", ACTION==\"add\", ATTR{address}==\"$(cat /sys/class/net/$OLD_IFNAME/address)\",ATTR{type}=="$(cat /sys/class/net/OLD_IFNAME/type)",NAME=\"$NEW_IFNAME\"" >> $UDEV_RULES_FILE
echo "网卡名创建成功"
echo "修改现有连接的的网卡"
read -p "请输入需要修改的连接名称(例如ens33):" connetion
nmcli connection modify $connection  connection.interface-name $NEW_IFNAME
