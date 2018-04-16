#!/bin/bash

# -------------------------------------------------------------------------------
# Filename:    tar_unpack_check.sh
# Revision:    1.1
# Date:        2018/04/12
# Author:      yagetang
# Email:       yagetang#163.com
# Website:     blog.yagetang.cn
# Description: Plugin to  unpack the projectname.tar.gz
# Notes:       This plugin uses the "" command
# -------------------------------------------------------------------------------
# Copyright:   2018 (c) yagetang
# License:     GPL
# OS: Centos 7

export LANG=zh_CN.UTF-8

if [[ -f /etc/guard.conf && -f /etc/profile ]];then
    source /etc/guard.conf
    source /etc/profile
else
    echo "$(date +%Y-%m-%d" "%T) [ERR] : /etc/guard.conf  file not exist." >> /var/log/guard.log
    exit
fi
function func_uppack_file()
{
    if [[ -f ${projectRsyncTar} ]];then
          /usr/bin/tar -zxf ${projectRsyncTar} -C ${projectRoot}/
          echo "$(date +%Y-%m-%d" "%T) [INFO] : 执行解包中..."  >> /var/log/guard.log
    else
          echo "$(date +%Y-%m-%d" "%T) [ERR] : The package file does not exist，Please check the ${projectRsyncDir}" catalogue. >> /var/log/guard.log
          exit
    fi
}

function func_uppack_md5()
{
    if [[ -f ${projectRsyncMd5} ]];then
       echo "$(date +%Y-%m-%d" "%T) [INFO] : 执行md5对比解包"  >> /var/log/guard.log
       new_md5=`cat "$projectRsyncMd5"`
       echo "$(date +%Y-%m-%d" "%T) [INFO] : ${new_md5}"  >> /var/log/guard.log
       if [[ -f ${projectLocalMd5} ]];then
          locad_md5=`cat "$projectLocalMd5"`
       else
          locad_md5=0
       fi
       echo "$(date +%Y-%m-%d" "%T) [INFO] : ${locad_md5}"  >> /var/log/guard.log
       
       if [[ "$new_md5" != "$locad_md5" ]];then
          func_uppack_file
          /usr/bin/cp -rf "$projectRsyncMd5" "$projectLocalMd5"
          echo "$(date +%Y-%m-%d" "%T) [INFO] : copy md5 succcess"  >> /var/log/guard.log
       fi
    else
       echo "$(date +%Y-%m-%d" "%T) [ERR] : The package file does not exist，Please check the ${projectRsyncDir}" catalogue. >> /var/log/guard.log
       exit
    fi
}

function func_uppack_release()
{
  
    if [[ ${projectIsMaster} == "True" ]];then
        echo "$(date +%Y-%m-%d" "%T) [INFO] : 执行master的md5对比解包"  >> /var/log/guard.log
        func_uppack_md5
    else 
        if [[ -f ${projectRsyncMd5} && -f ${projectRsyncRelease} ]];then
           echo "$(date +%Y-%m-%d" "%T) [INFO] : 执行slave的release对比解包"  >> /var/log/guard.log
           echo "$(date +%Y-%m-%d" "%T) [INFO] : 执行release对比解包"  >> /var/log/guard.log
           new_release=`cat "$projectRsyncRelease"`
           echo "$(date +%Y-%m-%d" "%T) [INFO] : ${new_release}"  >> /var/log/guard.log
        if [[ -f ${projectLocalRelease} ]];then
           locad_release=`cat "$projectLocalRelease"`
       else
           locad_release=0
       fi
       echo "$(date +%Y-%m-%d" "%T) [INFO] : ${locad_release}"  >> /var/log/guard.log

       if [[ "$new_release" != "$locad_release" ]];then
           func_uppack_file
           /usr/bin/cp -rf "$projectRsyncMd5" "$projectLocalMd5"
           /usr/bin/cp -rf "$projectRsyncRelease" "$projectLocalRelease"
           echo "$(date +%Y-%m-%d" "%T) [INFO] : copy release success"  >> /var/log/guard.log
        fi
        else
            echo "$(date +%Y-%m-%d" "%T) [ERR] : The package file does not exist，Please check the ${projectRsyncDir}" catalogue. >> /var/log/guard.log
            exit
        fi
    fi

}

if [[ ${envType} != "prod" ]];then
    func_uppack_md5
else
    func_uppack_release
fi
