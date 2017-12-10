#!/usr/bin/env bash


#/sys/class/net/eth0/statistics/rx_packets: 收到的数据包数据
#/sys/class/net/eth0/statistics/tx_packets: 传输的数据包数量
#/sys/class/net/eth0/statistics/rx_bytes: 接收的字节数
#/sys/class/net/eth0/statistics/tx_bytes: 传输的字节数
#/sys/class/net/eth0/statistics/rx_dropped: 当收到包数据包下降的数据量
#/sys/class/net/eth0/statistics/tx_dropped: 传输包数据包下降的数据量


function get_pkgs(){
    rx_packets=$(cat /sys/class/net/eth0/statistics/rx_packets)
    tx_packets=$(cat /sys/class/net/eth0/statistics/tx_packets)
    rx_bytes=$(cat /sys/class/net/eth0/statistics/rx_bytes)
    tx_bytes=$(cat /sys/class/net/eth0/statistics/tx_bytes)

    rx_kb=$[$rx_bytes/1024/1024]
    tx_kb=$[$tx_bytes/1024/1024]
}

function print(){
    get_pkgs
    echo -n "数据包/收: ";
    echo -n "数据包/发: ";
    echo -n "数据包/发-字节: "${rx_kb} Mb;
    echo -n "数据包/收-字节: "${tx_kb} Mb;
    sleep 1
}

while :;do
    print
    echo
    sleep 1
done
