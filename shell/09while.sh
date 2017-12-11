#!/usr/bin/env bash

#while :;do
#    echo `date`
#    sleep 2
#done
#


#分析：如果没有输入参数（参数的总数为0），提示错误并退出；反之，进入循环；若第一个参数不为空字符，则创建以第一个参数为名的用户，并移除第一个参数，将紧跟的参数左移作为第一个参数，直到没有第一个参数，退出。
while(($#>0))
do
    echo $*
    shift
done