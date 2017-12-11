#!/usr/bin/env bash

read -p "pls input your age": age

if [[ $age =~ [^0-9] ]];then
    echo "pls input a int"
    exit 10
elif [ $age -ge 150 ];then
    echo "your age is wrong"
elif [ $age -gt 18 ];then
    echo "good good work"
else
    echo "good good study"
fi
