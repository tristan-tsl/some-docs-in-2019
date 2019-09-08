搭建nginx

```
yum install -y nginx
systemctl enable nginx
systemctl start nginx
systemctl reload nginx

find / | grep nginx.conf
/etc/nginx/nginx.conf
/etc/nginx/nginx.conf.default

vi /etc/nginx/nginx.conf

server {
	listen       80;
	server_name  translation.googleapis.com;

	#charset koi8-r;

	#access_log  logs/host.access.log  main;

	#location / {
	#    root   html;
	#    index  index.html index.htm;
	#}
	
	location / {
				proxy_pass https://translation.googleapis.com;
	}
```



配置证书

```
openssl genrsa -des3 -out ca.key 2048
openssl req -new -x509 -days 7305 -key ca.key -out ca.crt

openssl genrsa -des3 -out cert.key 1024
openssl req -new -key cert.key -out cert.csr
openssl x509 -req -in cert.csr -out cert.pem -signkey cert.key -CA ca.crt -CAkey ca.key -CAcreateserial -days 3650

openssl rsa -in cert.key -out uncert.key
mv -f uncert.key cert.key
```

