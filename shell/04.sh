#!/usr/bin/env bash

clear
for i in $(seq 10);do
    echo $i
    sleep 1
done

for((i=1;i<=10;i++));do
    echo $i
done


for yaml in *.yaml; do
  eval "${KUBECTL} create -f \"${yaml}\""
done

eval "${KUBECTL} get pods $@"