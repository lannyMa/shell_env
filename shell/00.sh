#!/usr/bin/env bash

1、生成随机字符 cat /dev/urandom

生成8个随机大小写字母或数字 cat /dev/urandom |tr -dc [:alnum:] |head -c 8

2、生成随机数 echo $RANDOM

确定范围 echo $[RANDOM%7] 随机7个数（0-6）

 echo $[$[RANDOM%7]+31] 随机7个数（31-37）

3、echo打印颜色字

echo -e "\033[31$1\033[0m" 显示红色along

echo -e "\033[1;31$1\033[0m" 高亮显示红色along

echo -e "\033[41$1\033[0m" 显示背景色为红色的along

echo -e "\033[31;5$1\033[0m" 显示闪烁的红色along

color=$[$[RANDOM%7]+31]

echo -ne "\033[1;${color};5m*\033[0m" 显示闪烁的随机色along

# --------------------------------

# 打印红色
print_red() {
  printf '%b' "\033[91m$1\033[0m\n"
}

# 打印绿色
print_green() {
  printf '%b' "\033[92m$1\033[0m\n"
}

# 亮红色
print_fire_red(){
    printf 'b' "\033[1;31$1\033[0m"
}

# 背景色为空色
print_back_red(){
    printf 'b' "\033[41$1\033[0m"
}

# 闪烁的红色
print_spark_red(){
    printf 'b' "\033[31;5$1\033[0m"
}

print_red $1
print_green $1
print_fire_red $1
print_back_red $1
print_spark_red $1

