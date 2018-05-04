#!/bin/bash

# -------------------------------------------------------------------------------
# Filename:    sys_config_terminal.sh
# Revision:    1.2
# Date:        2018/04/15
# Author:      yagetang
# Email:       yagetang#163.com
# Website:     blog.yagetang.cn
# Description: Plugin to  config the system terminal
# Notes:       This plugin uses the "" command
# -------------------------------------------------------------------------------
# Copyright:   2018 (c) yagetang
# License:     GPL
# OS: Centos 7

export LANG=zh_CN.UTF-8

if [[ -f /etc/profile.d/sys_env.sh ]];then
    source /etc/profile
else
    echo "$(date +%Y-%m-%d" "%T) [ERR] : /etc/profile.d/sys_env.sh  file not exist."
    exit
fi

#获取环境编码
get_envnu=$(hostname |awk -F'.' '{print $2}')

#获取ip地址信息
get_ipinfo=`ifconfig | grep 'inet' | grep -v '127.0.0.1' |grep -v 'inet6' |awk -F" " '{print $2}'|sed 's/\./-/g'`

#获取已有可登陆用户
home_user=`ls /home/`

#添加PS1='\[\e[32;1m\][test]\[\e[0m\][\u@\h-127-0-0-1 \W]\$ '
for user_name in ${home_user}  "root";
do

  if [[ "${user_name}" = "root" ]];then
     if [[ `cat /"${user_name}"/.bashrc |grep ^"PS1" |wc -l` -eq 0 ]];then
        echo PS1="'\[\e[32;1m\][$envType-$envArea]\[\e[0m\][\u@\h-$get_ipinfo \W]\\$ '" >> /${user_name}/.bashrc
        source /${user_name}/.bashrc
     fi
  else
     if [[ `cat /home/${user_name}/.bashrc |grep ^"PS1" |wc -l` -eq 0 ]];then
        echo PS1="'\[\e[32;1m\][$envType-$envArea]\[\e[0m\][\u@\h-$get_ipinfo \W]\\$ '" >> /home/${user_name}/.bashrc
        source /home/${user_name}/.bashrc
     fi
  fi

done
