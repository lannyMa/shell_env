#!/usr/bin/env bash

read -p "pls input your score: " score

if [[ $score =~ [^0-9] ]];then
    echo "pls input a int"
    exit 10
elif [ $score -ge 100 ];then
    echo "score wrong"
    exit 20
elif [ $score -ge 85 ];then
    echo "your score is very good"
elif [ $score -ge 60 ];then
    echo "your score is soso"
else
    echo "you are loser"
fi

