#!/usr/bin/env bash

for((i=1;i<=10;i++));do
    echo $i
done

if((10<20));then
    echo 123213123123213213213213
fi

[ 'maotai' == 'maotai1' ] || echo 'no no no'

[[ $num =~ [^0-9] ]]