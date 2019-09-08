C:\\Users\\tristan\\Downloads\\apache-skywalking-apm-6.2.0\\apache-skywalking-apm-bin\\agent


java -javaagent:C:\\Users\\tristan\\Downloads\\apache-skywalking-apm-6.2.0\\apache-skywalking-apm-bin\\agent\\skywalking-agent.jar -jar cloud-eureka-1.1-SNAPSHOT.jar


http://gitlab.yibainetworklocal.com/project/code/maintenance/skywalking/skywalking/uploads/733b435086ceef9a934470a2e22c4760/apache-skywalking-apm-6.2.0.tar.gz




https://github.com/docker/compose/releases/download/1.24.0/docker-compose-Linux-x86_64


http://192.168.86.121:8080
192.168.86.121:11800



docker pull apache/skywalking-ui:6.2.0

docker run --name oap --restart always -d -e SW_OAP_ADDRESS=192.168.86.121:12800 apache/skywalking-ui



docker pull apache/skywalking-oap-server:6.2.0

docker run --name oap --restart always -d -e SW_STORAGE=elasticsearch -e SW_STORAGE_ES_CLUSTER_NODES=elasticsearch:9200 apache/skywalking-oap-server

curl http://192.168.86.121:9200/_cluster/health?pretty


mkdir -p /data/tristan && cd /data/tristan

git clone https://github.com/SkyAPM/SkyAPM-php-sdk.git

# 检出分支
git checkout tags/3.1.4

cd SkyAPM-php-sdk
phpize
./configure
make
sudo make install
 
vi /usr/local/php/etc/php.ini


php.ini

; Loading extensions in PHP
extension=skywalking.so
; enable skywalking
skywalking.enable = 1
; Set skyWalking collector version
skywalking.version = 6
; Set app code e.g. MyProjectName
skywalking.app_code = hello_skywalking
; Set skywalking php agent sock path
skywalking.sock_path=/tmp/sky_agent.sock

service php-fpm restart


php -m | grep skywalking

参考文档: https://github.com/SkyAPM/SkyAPM-php-sdk/blob/3.1.4/docs/zh/install-sdk.md


https://github.com/SkyAPM/SkyAPM-php-sdk/releases

cd ..
wget https://github.com/SkyAPM/SkyAPM-php-sdk/releases/download/3.1.5/sky_php_agent_linux_x64

rm -rf /usr/local/bin/sky_php_agent_linux_x64
rm -rf /usr/bin/sky_php_agent_linux_x64

cp sky_php_agent_linux_x64 /usr/local/bin/sky_php_agent_linux_x64
chmod +x /usr/local/bin/sky_php_agent_linux_x64
ln -s /usr/local/bin/sky_php_agent_linux_x64 /usr/bin/sky_php_agent_linux_x64

nohup sky_php_agent_linux_x64 192.168.86.121:11800 /tmp/sky_agent.sock &

yum install -y iftop
iftop -n