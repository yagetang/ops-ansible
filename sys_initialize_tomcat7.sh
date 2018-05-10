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

if [[ -f /etc/guard.conf ]];then
    source /etc/guard.conf
else
    echo "$(date +%Y-%m-%d" "%T) [ERR] : /etc/guard.conf  file not exist." >> /var/log/guard.log
    exit
fi

function func_create_workdir()
{
  if [[ ! -d $workRoot ]];then
      mkdir -p ${workRoot} 
  fi
  mkdir ${projectSecconf}
  mkdir ${projectRoot}
  mkdir ${projectLogs}
  mkdir ${projectTemp}
  mkdir ${projectRsyncDir}
  mkdir ${workRoot}/verify
  if [[ ! -f ${projectSecconf}/default_exclude ]];then
     touch ${projectSecconf}/default_exclude
  fi
}

function func_create_tomcatdir()
{
  if [[ ! -d ${appRoot} ]];then
       yum install java-1.8.0-openjdk java-1.8.0-openjdk-devel bc -y
       wget -O /tmp/apache-tomcat-7.0.79.tar.gz http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.79/bin/apache-tomcat-7.0.79.tar.gz 
       tar  -zxvf /tmp/apache-tomcat-7.0.79.tar.gz -C /tmp/
       mv /tmp/apache-tomcat-7.0.79 ${appRoot}
  fi
}

function func_create_tomcatuser()
{
  case $(hostname |awk -F'-' '{print $1}') in
        "server"|"java")
            appUser="tomcat"
            ;;
        "js"|"nodejs")
            appUser="nodejs"
            ;;
        *)
            appUser="www"
            ;;
  esac

  if [[ `cat /etc/passwd |grep ${appUser} |wc -l` -eq 0 ]];then groupadd ${appUser};useradd -M -s /sbin/nologin -g ${appUser} ${appUser}; fi
  chown -R ${appUser}:${appUser} ${workRoot}
  chown -R ${appUser}:${appUser} ${appRoot}
}

func_create_workdir
func_create_tomcatdir
func_create_tomcatuser
