# php



# gRPC PHP extension

```
pecl install grpc
```

### gRPC C core library

```
git clone -b $(curl -L https://grpc.io/release) https://github.com/grpc/grpc

# gRPC C core library
cd grpc
git submodule update --init
make
sudo make install

# gRPC PHP extension
cd grpc/src/php/ext/grpc
phpize
./configure
make
sudo make install
```

### Update php.ini

```
vi php.ini

extension=grpc.so
```

## Install Protobuf compiler

```
cd grpc/third_party/protobuf
./autogen.sh && ./configure && make
sudo make install

sudo pecl install protobuf

vi php.ini
extension=protobuf.so
```



```
cd grpc
make grpc_php_plugin
```

