#!/usr/bin/env bash
echo "准备安装ss"
echo "安装python环境"
curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
python get-pip.py
pip install --upgrade pip
echo "使用python安装ss"
pip install shadowsocks
echo "修改ss的配置文件"
echo "" > /etc/shadowsocks.json
tee /etc/shadowsocks.json <<-'EOF'
{
  "server":"47.75.178.15",
  "server_port":12294,
  "local_address": "127.0.0.1",
  "local_port":1985,
  "password":"ssrTristan",
  "timeout":300,
  "method":"aes-256-cfb",
  "workers": 1
}
EOF
echo "启动ss客户端"
nohup sslocal -c /etc/shadowsocks.json &
ps aux|grep sslocal
echo " nohup sslocal -c /etc/shadowsocks.json /dev/null 2>&1 &" /etc/rc.local
echo "验证ss客户端是否可用"
curl --socks5 127.0.0.1:1985 http://httpbin.org/ip

echo "准备安装Privoxy"
echo "创建用户"
useradd privoxy
echo "下载privoxy安装文件"
yum install -y wget
wget https://gitlab.com/tristan-pass/infrastructure/proxy-server/raw/master/privoxy-3.0.26-stable-src.tar.gz
echo "解压文件"
tar -zxvf privoxy-3.0.26-stable-src.tar.gz
cd privoxy-3.0.26-stable
echo "加载配置并编译"
yum install install -y autoconf automake libtool
autoheader && autoconf
./configure
yum -y install gcc automake autoconf libtool make
make && make install
echo "修改配置"
echo "forward-socks5t / 127.0.0.1:1985 ." >> /usr/local/etc/privoxy/config
echo "启动privoxy"
privoxy --user privoxy /usr/local/etc/privoxy/config
echo "启动成功"

echo "验证ss是否可用"
export http_proxy=http://127.0.0.1:8118
export https_proxy=http://127.0.0.1:8118
echo "wget http://baidu.com"
wget http://baidu.com
echo "wget https://baidu.com"
wget https://baidu.com
echo "wget http://google.com"
wget http://google.com
echo "wget https://google.com"
wget https://google.com