#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:/sbin
export PATH
function docker(){
       curl -fsSL https://get.docker.com -o get-docker.sh  && \
       bash get-docker.sh
       service docker restart 
       systemctl enable docker
}

function v2ray1(){
        echo " "
        read -p "容器名字 参考格式 v2ray，容器名同一服务器不能重复:" name
        echo " "

        echo " "
        read -p "请输入数据库IP 参考格式 1.1.1.1:" MYSQLHOST
        echo " "

        echo " "
        read -p "数据库用户名 参考格式 sspanel:" MYSQLDBNAME
        echo " "

        echo " "
        read -p "数据库密码 参考格式 sspanel:" MYSQLPASSWD
        echo " "

        echo " "
        read -p "请输入节点ID 参考格式 6:" node_id
        echo " "

        echo " "
        read -p "流媒体解锁IP 没有不要填:" answer
          if [ -z "$answer" ]; then
        LDNS="8.8.8.8"
        else
        LDNS=$answer
        fi
        echo " "

        echo " "
        read -p "请输入CF Key :" CF_Key
        echo " "

        echo " "
        read -p "请输入CF Email :" CF_Email
        echo " "

        echo " "
        read -p "请输入api_port端口 参考格式 2336，同服务器多节点不能重复[1-65535]:" api_port
        echo " "
        
        docker run -d --name=$name -e speedtest=0 -e api_port=$api_port -e usemysql=1 -e downWithPanel=0 -e node_id=$node_id -e LDNS=$LDNS -e MYSQLHOST=$MYSQLHOST -e MYSQLDBNAME="$MYSQLDBNAME" -e MYSQLUSR="$MYSQLUSR" -e MYSQLPASSWD="$MYSQLPASSWD"  -e MYSQLPORT=3306 -e CF_Key=$CF_Key -e CF_Email=$CF_Email --log-opt max-size=10m --log-opt max-file=5 --network=host --restart=always bobkjl/v2ray:4.22.1.8

        echo -e "\033[42;37m 安装完成 \033[0m"
}
function v2ray2(){
        echo " "
        read -p "容器名字 参考格式 v2ray，容器名同一服务器不能重复:" name
        echo " "

        echo " "
        read -p "请输入数据库IP 参考格式 1.1.1.1:" MYSQLHOST
        echo " "

        echo " "
        read -p "数据库用户名 参考格式 sspanel:" MYSQLDBNAME
        echo " "

        echo " "
        read -p "数据库密码 参考格式 sspanel:" MYSQLPASSWD
        echo " "

        echo " "
        read -p "请输入节点ID 参考格式 6:" node_id
        echo " "

        echo " "
        read -p "流媒体解锁IP 没有不要填:" answer
          if [ -z "$answer" ]; then
        LDNS="8.8.8.8"
        else
        LDNS=$answer
        fi
        echo " "

        echo " "
        read -p "请输入CF Key :" CF_Key
        echo " "

        echo " "
        read -p "请输入CF Email :" CF_Email
        echo " "

        echo " "
        read -p "请输入api_port端口 参考格式 2336，同服务器多节点不能重复[1-65535]:" api_port
        echo " "

        docker run -d --name=$name -e speedtest=0 -e api_port=$api_port -e usemysql=1 -e downWithPanel=0 -e node_id=$node_id -e LDNS=$LDNS -e MYSQLHOST=$MYSQLHOST -e MYSQLDBNAME="$MYSQLDBNAME" -e MYSQLUSR="$MYSQLUSR" -e MYSQLPASSWD="$MYSQLPASSWD"  -e MYSQLPORT=3306 -e CF_Key=$CF_Key -e CF_Email=$CF_Email --log-opt max-size=10m --log-opt max-file=5 --network=host --restart=always bobkjl/v2ray_v3:go_pay

        echo -e "\033[42;37m 安装完成 \033[0m"
}
function menu(){
    echo "###       v2ray tool v1.1.0       ###"
    echo "###       By @DerrickZH           ###"
    echo "###       Update: 2020-04-01      ###"
    echo ""
    echo -e "适用Rico v2ray后端"
    echo "---------------------------------------------------------------------------"

    echo -e "[1] 安装Docker"
    echo -e "[2] 安装付费版"
    echo -e "[3] 安装免费版"
#   echo -e "[4] 捐赠开发者"
    echo -e "请输入选项以继续，ctrl+C退出"

    opt=0
     read opt
    if [ "$opt" = "1" ]; then
        docker

    elif [ "$opt" = "2" ]; then
        v2ray1
        
    elif [ "$opt" = "3" ]; then
        v2ray2
		
    elif [ "$opt" = "4" ]; then
        donate
    
    else
        echo -e "输入错误"
        bash ./node-install.sh
    fi
}
menu
