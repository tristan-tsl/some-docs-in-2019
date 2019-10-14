#!/usr/bin/env bash
echo "初始化系统"
yum install -y wget
wget  http://mirrors.aliyun.com/repo/Centos-7.repo
mv Centos-7.repo /etc/yum.repos.d/CentOs-Base.repo
yum clean all
yum makecache
yum update
echo "初始化中文语言环境"
locale -a | grep zh_CN
echo "安装中文相关"
yum install -y kde-l10n-Chinese
echo "修改本地语言配置"
cat >> /etc/sysconfig/i18n<<EOF
LANG="zh_CN.UTF-8"
LC_ALL="zh_CN.UTF-8"
EOF
source /etc/sysconfig/i18n

cat >> /etc/locale.conf<<EOF
LANG="zh_CN.UTF-8"
EOF
source /etc/locale.conf