#!/bin/bash

# -------------------------------------------------------------------------------
# Filename:    sys_initialization.sh
# Revision:    1.1
# Date:        2018/04/05
# Author:      yagetang
# Email:       yagetang#163.com
# Website:     blog.yagetang.cn
# Description: Plugin to  initialization installation the system
# Notes:       This plugin uses the "" command
# -------------------------------------------------------------------------------
# Copyright:   2018 (c) yagetang
# License:     GPL
# OS: Centos 7

export LANG=zh_CN.UTF-8

workuser=work

function func_system_initialization()
{

  #关闭防火墙
  systemctl stop firewalld.service
  systemctl disable firewalld.service

  #关闭selinux
  cp /etc/sysconfig/selinux /etc/sysconfig/selinux.backup
  sed -i 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/sysconfig/selinux
  setenforce 0

  #时间设置
   #mv /etc/localtime "/tmp/localtime.$(date +%Y%m%d%H%M%S)"
   #cp /usr/share/zoneinfo/Asia/Shanghai /etc/local-time
   #如果未安装/ntpdate，则安装它
   if [ ! -f "/usr/sbin/ntpdate" ]; then yum install ntpdate -y; fi 
   /usr/sbin/ntpdate ntp6.aliyun.com >/dev/null 2>&1 ; /sbin/hwclock --systohc
   hwclock
   echo "3 */2 * * * /usr/sbin/ntpdate ntp6.aliyun.com >/dev/null 2>&1 ; /sbin/hwclock --systohc"  >> /var/spool/cron/root

  #更新aliyun yum源
   if [ ! -f "/usr/bin/wget" ]; then yum install ntpdate -y; fi
   yum install wget -y
   if [ -f "/etc/yum.repos.d/CentOS-Base.repo" ]; then mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup; fi  
   wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo    
   if [ -f "/etc/yum.repos.d/epel.repo" ]; then mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup; fi  
   if [ -f "/etc/yum.repos.d/epel-testing.repo" ]; then mv /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup; fi
   wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

}
####
#系统软件初始化
#func_software_initialization
####
function func_software_initialization()
{   
   #安装系统工具
   yum install vim lrzsz iftop iotop ntpdate ncdu gcc-c++ nc tree net-tools nmap vim bash-completion lsof dos2unix telnet ntp rng-tools psmisc tmux unzip zip bc -y
   yum install zlib zlib-devel openssl openssl--devel pcre pcre-devel -y
   #yum install cloud-init cloud-utils-growpart dracut-modules-growroot -y
   #dracut -f
}

####
#系统软件初始化
#func_adduser_initialization
####
function func_adduser_initialization()
{   

 if [[ `cat /etc/passwd |grep ^${workuser} |wc -l` -eq 0 ]];then
	useradd ${workuser}
        if [ ! -d "/home/${workuser}/.ssh" ]; then mkdir /home/${workuser}/.ssh; fi
	chown work:work /home/${workuser}/.ssh
	chmod 700 /home/${workuser}/.ssh
	#echo "添加用户key
	echo -n -e "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQ+R2L/zPX3Lnl5FcWjbdL3dWJzqpfb0bZI5J0PUbDdEBVUVssKXVNsWz9SmZvL5quhQgBttbFc3ctewQWzbcwa14HFcdEx286FLsAiG8jqtDKS/W++qgeTrWDSzXigSlAvSHbJVRI3CcwBLfrRGKTMM+Itr0H1STsRdDc8bbjFYXYP2XrKMYuFYyjqslm0RHX+LXAauxEluAZPqPUxKBiEudVyv+RBTeAPSqcnFhoozkEhhVuTaRjn0Hvi2kMKd1ShHhWPerr//5Wfr46g71OT3nXWnrps0RKtsVkR6eKGC7htEU2pXGANbmyo07MChYMHwbivHvTwGpSB2AQzsSJ tangdeshuai
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAvF5EqAHYxCh3/nIM4W5UMsQ+UPgT8qXM05amBsaAgj/TUG4M9+uz83JIHv2Xe6YLDUOY3smnadCnTBCMQtBp7RUW6r3+vYOryUWkFyW1cnr+HJufoeOSgfhxhTybS+YWHBriB5UMLVbq1dTAiEdNOmCUZF32kY8g5vBwcD5jH9lgb88zlyMznOTXF1rnln33hDnMO3X+z6qOiZtiJPvsL/dH2Ft+aqhAghLlOq3NXNZcfMkAhqX0Q33jd8Xc94P5kwBeYDcfmxUJ9vltDbJ6XZn4bT4jozhB9zglzKsWMqLj3gRiD76Ziu2UILgzsnQZj6WQLMuB05MSi0W/JbQ== luojiwei
ssh-dss AAAAB3NzaC1kc3MAAACBAMFWItAattUUGzxBr+GSdO10MX1c5TLPth2sNHprax/LbxS/UHXTrvOuVkQfwQlgs5oIhejmhwQX9Sn57+faBbxDmJQsxTh+bCITDsjz+rCAiq8yKIx4Cahms9k4qQ2Ethk9CjMbaq1FJvNPfS/GDNA6IcUfczziTlnvZLMtPNixAAAAFQDfh4fbgYXFq2sdFToQWHskTOMOnQAAAIEAqlgQ1Dn8/izaUCz/c+pFNOuOhgXze+1//627qNVS4EG3TX5EApy06/OUw0jxWJD/1DjA1/L7+8VskxqmEQMI65njibvK58w+juevrnbyVCn06LZGYLFPvhknuADAapFCPSwlnSQBp6hnN+LTBCeEPpm1SjBddxENgsVHRISmYfYAAACBAJDuSYu59i8AiqG0g9B6gF9jSExauwDPLNm1WFYzf/ddEpcZmWoRwlGHNCG97FrFt0Vf6Wo/jqmm9Clnq/QIK+O8o7lWgemHIgOqVdTMYEPbzrM5KHqrGkkDwTDOlm/JoYiY+gg/lul+dEhlIorlOsRiWikWCSwxqsxne2NdPWdu waz_hx file" >> /home/${workuser}/.ssh/authorized_keys
        if [ -f "/etc/sudoers.d/work-init-users" ]; then echo -e "# User rules for work\nwork ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/work-init-users; else echo -e "# User rules for work\nwork ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/work-init-users;fi
        chmod 660 /etc/sudoers.d/work-init-users
	chown work:work /home/${workuser}/.ssh/authorized_keys
	chmod 600 /home/${workuser}/.ssh/authorized_keys
        #开启key认证
        sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
        #禁止用户密码登陆
        sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
 fi

}

func_system_initialization

func_software_initialization

func_adduser_initialization

shutdown -r now
