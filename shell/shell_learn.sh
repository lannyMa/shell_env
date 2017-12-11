#!/usr/bin/env bash

#
#The "$@" are all the existing position paramters.
#
#
##!/usr/bin/env bash
echo 'hello'




#p_args(){
#    echo "第一个参数是: $1"
#    echo "第二个参数是: $2"
#    echo "第三个参数是: $3"
#    echo "第四个参数是: $4"
#    echo "总共有参数: $# 个"
##    echo "作为一个字符串输出所有参数: $* "
#}
#p_args $*

print_red() {
  printf '%b' "\033[91m$1\033[0m\n"
}

print_green() {
  printf '%b' "\033[92m$1\033[0m\n"
}

num=1992

testvar(){
    local num=10
    ((num++))
    echo $num
}
testvar

echo $num


echo $RANDOM