#!/usr/bin/env bash

#扫描系统中SUID权限，以免系统为被别人开后门。
#搜索系统中的所有拥有SUID和SGID的文件，并保存到临时目录。
find / -perm -4000 -o -perm -2000 > /tmp/setuid.check
for i in $(cat /tmp/setuid.check)
#做循环取出临时文件中的文件名
do
  grep $i /root/suid.log /dev/null
     #比对这个文件名是否在模板文件中
     if [ "$?" != "0" ]
        #检测上一个命令的返回值，如果不为0报错
     then
        echo "$i usb't in listfile! " >> /root/suid.log_$(date +%F)
  #如果文件名不再模板文件中 输出，并把错记录日志中

    fi
done
rm -rf /tmp/setuid.check