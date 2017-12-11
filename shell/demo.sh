#!/usr/bin/env bash

name="name age gender address"



registry='"L3JlZ2lzdHJ5L25hbWVzcGFjZXMvZGVmYXVsdA=="
"L3JlZ2lzdHJ5L25hbWVzcGFjZXMva3ViZS1wdWJsaWM="
"L3JlZ2lzdHJ5L25hbWVzcGFjZXMva3ViZS1zeXN0ZW0="'

echo $registry

for i in $registry;do
    echo $i|sed "s#\"##g"|base64 -d
    echo
done


$ cat registry.sh
#!/bin/bash
set -ue
clear

registry=`ETCDCTL_API=3 etcdctl get /registry/namespaces --prefix -w=json|python -m json.tool|grep key|awk -F":" '{ print $2 }'|tr "," " "`

for i in $registry;do
    echo $i|sed "s#\"##g"|base64 -d
    echo
done

$ sh registry.sh
/registry/namespaces/default
/registry/namespaces/kube-public
/registry/namespaces/kube-system

