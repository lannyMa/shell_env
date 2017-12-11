#!/usr/bin/env bash


#+++++++++++++++++++++++++++
# 临时禁止某ip的tcp流量
# ssh安全: https://www.ibm.com/developerworks/cn/aix/library/au-sshsecurity/index.html
#+++++++++++++++++++++++++++
vim /etc/hosts.deny
ALL: 192.168.14.133


#+++++++++++++++++++++++++++
# 添加kownhosts, 使ssh不提示yes
#+++++++++++++++++++++++++++
# Store github.com SSH fingerprint
RUN mkdir -p ~/.ssh && ssh-keyscan -H github.com | tee -a ~/.ssh/known_hosts




