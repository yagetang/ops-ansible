#!/bin/bash

# -------------------------------------------------------------------------------
# Filename:    sys_env.sh
# Revision:    1.1
# Date:        2018/04/05
# Author:      yagetang
# Email:       yagetang#163.com
# Website:     blog.yagetang.cn
# Description: Plugin to  config the system
# Notes:       This plugin uses the "" command
# -------------------------------------------------------------------------------
# Copyright:   2018 (c) yagetang
# License:     GPL
# OS: Centos 7

export LANG=zh_CN.UTF-8

#获取环境编码
get_envnu=$(hostname |awk -F'.' '{print $2}')

#转换环境编码
case ${get_envnu:0:3} in 
         001) 
           export envType="dev"
         ;; 
         010) 
           export envType="test"
         ;;
         011) 
           export envType="testing"
         ;;
         100) 
           export envType="stage"
         ;;    
         101) 
           export envType="prod"
         ;; 
         *) 
           export envType="enverr"
         ;; 
 esac

#转换地区编码
case ${get_envnu:3:3} in
         001)
           export envArea="cqyb"
         ;;
         010)
           export envArea="hd1b"
         ;;
         011)
           export envArea="hd1d"
         ;;
         100)
           export envArea="hd2a"
         ;;
         101)
           export envArea="hd2b"
         ;;
         *)
           export envArea="areaerr"
         ;;
 esac

#case ${get_envnu:0-4} in
#	1001)
#	  projectIsMaster=True
#	;;
#        *)
#	  projectIsMaster=False
#	;;
#esac
#识别主从服务器
#测试验证
#if [[ $((${get_envnu:0-4} % 2)) -eq 0 ]];then
#正式使用
if [[ $((${get_envnu:0-4} % 2)) -ne 0 ]];then
	projectIsMaster=True
else
	projectIsMaster=False
fi
