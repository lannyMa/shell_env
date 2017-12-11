#!/usr/bin/env bash

read -p "pls input yes or no: " ans
case $ans in
[yY][eE][yY])
   echo yes
   ;;
[nN][oO][nN])
   echo no
   ;;
*)
   echo false
   ;;
esac


case $1 in
start | begin)
    echo "start something"
    ;;
stop | end)
    echo "stop something"
    ;;
*)
    echo "Ignorant"
    ;;
esac
