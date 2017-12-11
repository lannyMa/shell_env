#!/usr/bin/env bash


print_red() {
  printf '%b' "\033[91m$1\033[0m\n"
}

print_green() {
  printf '%b' "\033[92m$1\033[0m\n"
}
echo
echo '----------------------'

print_green "how is going everybody!"
print_red "you are doing stupid things!"


printf "%s ----- %s" "maotai" "hello world"
run_time="`date '+%Y-%m-%d %H:%M:%S'`"
printf "%s - [INFO] - run_user[${USER}] - msg_or_rc[%s]\n" "$(run_time)" "step 1 is over"



log_write(){
    run_time="`date '+%Y-%m-%d %H:%M:%S'`"
    msg = "%s - [INFO] - run_user: [${USER}] - msg:[%s]\n" "${run_time}" $1
}

log_write '1992 hello world'



echo "第一个参数是: $1"
echo "$@"




