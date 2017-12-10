#!/usr/bin/env bash
sed -eu
clear

function help(){
    echo "usage: xxx
          this is a test
    "
}


#if [ $# -eq 0 ];then
#    help
#elif [ $1 == "22" ];then
#    echo "22 happy"
#else
#    echo "default..."
#fi



if [ ! -z "$1" ];then
    echo $1
else
    echo "very sad"
fi