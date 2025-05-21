#!/bin/bash

arch=x86_64-linux-gnu
package_name=neuron-release

function usage() {
    echo "Usage: $0 "
    echo "-n package name [default: ${package_name}]"
    echo "-p target platform compiler prefix (opts: x86_64-linux-gnu, arm-linux-gnueabihf, aarch64-linux-gnu, ...)[default: x86_64-linux-gnu]"
}

while getopts "p:n:h-:" OPT; do
    case ${OPT} in
    p)
        arch=$OPTARG
        ;;
    n)
        package_name=$OPTARG
        ;;
    h)
        usage
        exit 0
        ;;
    \?)
        usage
        exit 1
        ;;
    esac
done

rm -rf ${package_name}/*

mkdir -p $package_name/certs
mkdir -p $package_name/config
mkdir -p $package_name/plugins/schema
mkdir -p $package_name/persistence
mkdir -p $package_name/logs

cp -r build/dist ${package_name}

cp build/neuron ${package_name}
cp build/libneuron-base.so ${package_name}
cp /usr/local/lib/libzlog.so.1.2 ${package_name}

cp persistence/*.sql ${package_name}/config/

cp zlog.conf ${package_name}/config/
cp dev.conf ${package_name}/config/
cp default_plugins.json ${package_name}/config/
cp neuron.json ${package_name}/config/

cp build/plugins/schema/ekuiper.json \
    build/plugins/schema/monitor.json \
    build/plugins/schema/mqtt.json \
    build/plugins/schema/modbus-tcp.json \
    build/plugins/schema/file.json \
    ${package_name}/plugins/schema/

cp build/plugins/libplugin-ekuiper.so \
    build/plugins/libplugin-monitor.so \
    build/plugins/libplugin-mqtt.so \
    build/plugins/libplugin-modbus-tcp.so \
    build/plugins/libplugin-file.so \
    ${package_name}/plugins/

tar czf ${package_name}-linux-${arch}.tar.gz ${package_name}/
ls ${package_name}
rm -rf ${package_name}

echo "${package_name}-linux-${arch}.tar.gz"
