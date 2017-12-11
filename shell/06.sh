#!/usr/bin/env bash
clear

#位置参数变量
#echo "\$n 接收参数 0本身 1-9 位置参数 10以上用\${10}> $1 $2 $3 "
#echo "\$* 接收的是一个整体 $*"
#echo "\$@ 接收所有参数 但区分对待 $@"
#echo "\$# 接收参数的个数 $#"

#echo {1..10}|sed -i 's#^#$#g'


#
#-d     测试是否为目录。
#-f     判断是否为文件。
#
#-s     判断文件是否为空 如果不为空 则返回0,否则返回1
#-e     测试文件或目录是否存在。
#-r     测试当前用户是否有权限读取。
#-w     测试当前用户是否有权限写入。
#-x     测试当前用户是否有权限执行。
#语法:
#[ -d /etc/fstab ]




## 数字比较 字符串比较
[ 10 -gt 10 ] # -le 小于等于
[ $USER != root ] && echo "user"
[ $USER != root ] && echo "user" || echo "root"

#-eq     判断是否等于
#-ne     判断是否不等于
#-gt     判断是否大于
#-lt     判断是否小于
#-le     判断是否等于或小于
#-ge     判断是否大于或等于




## 内存不够用告警
FreeMem=`free -m | grep cache: | awk '{print $3}'`
[ $FreeMem -lt 1024 ] && echo "Insufficient Memory"

## 数字加减操作
((1992+1))


#生成序列:
#
#法1:
#
#[root@lanny ~]# seq 10 |sed 's#^#$#g'|tr "\n" " "
#$1 $2 $3 $4 $5 $6 $7 $8 $9 $10
#
#法2:
#
#[root@lanny ~]# seq -s " " 15|sed 's# # $#g'
#1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12 $13 $14 $15 #注两位要用括号扩起来.
#
#文本:
#
#[root@lanny day2]# cat q.sh
#echo $1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12 $13 $14 $15
#
#执行:
#[root@lanny day2]# sh q.sh {a..z}
#a b c d e f g h i a0 a1 a2 a3 a4 a5
#
#seq 10 |sed 's#^#$#g'|tr "\n" " "


for i in {1..10};do
    echo $i
    echo ${i}.bak_$(date +%F)
done



rename_files(){
    for i in *.bak;do
        mv $i ${i}.bak_$(date +%F)
    done
}
rename_files
## 或者先find > 追加到某个文件,
## 然后再 for i in `cat tmp.txt`;do done;
