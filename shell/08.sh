#!/usr/bin/env bash
clear

HTTP_SERVER=192.168.6.52:8000
load_images(){
    images=(
        kubernetes-dashboard-amd64_v1.5.1.tar.gz
        etc.tar.gz
        hosts
    )
    for i in "${!images[@]}"; do
#        curl -L http://$HTTP_SERVER/${images[$i]} > /root/images/${images[$i]}
#        docker load < /root/images/${images[$i]}
        echo ${images[$i]}
    done
}
load_images
