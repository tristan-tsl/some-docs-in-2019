#!/usr/bin/env bash
echo "安装jdk"
yum install -y java-1.8.0-openjdk
java -version
echo "安装网络插件"
yum install -y net-tools
echo "安装流量监控插件"
yum install -y epel-release
yum install -y iftop