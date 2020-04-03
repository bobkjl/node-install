#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:/sbin
export PATH
sh_ver="1.2.1"
github="raw.githubusercontent.com/bobkjl/node-install/master"

# 设置字体颜色函数
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"

function blue(){
    echo -e "\033[34m\033[01m $1 \033[0m"
}
function green(){
    echo -e "\033[32m\033[01m $1 \033[0m"
}
function greenbg(){
    echo -e "\033[43;42m\033[01m $1 \033[0m"
}
function red(){
    echo -e "\033[31m\033[01m $1 \033[0m"
}
function redbg(){
    echo -e "\033[37;41m\033[01m $1 \033[0m"
}
function yellow(){
    echo -e "\033[33m\033[01m $1 \033[0m"
}
function white(){
    echo -e "\033[37m\033[01m $1 \033[0m"
}

Update(){
    echo -e "当前版本为 [ ${sh_ver} ]，开始检测最新版本..."
    sh_new_ver=$(wget --no-check-certificate -qO- "http://${github}/node-install.sh"|grep 'sh_ver="'|awk -F "=" '{print $NF}'|sed 's/\"//g'|head -1)
    [[ -z ${sh_new_ver} ]] && echo -e "${Error} 检测最新版本失败 !" && start_menu
    if [[ ${sh_new_ver} != ${sh_ver} ]]; then
        echo -e "发现新版本[ ${sh_new_ver} ]，是否更新？[Y/n]"
        read -p "(默认: y):" yn
        [[ -z "${yn}" ]] && yn="y"
        if [[ ${yn} == [Yy] ]]; then
            wget -N --no-check-certificate http://${github}/node-install.sh && bash node-install.sh
            echo -e "脚本已更新为最新版本[ ${sh_new_ver} ] !"
        else
            echo && echo "    已取消..." && echo
        fi
    else
        echo -e "当前已是最新版本[ ${sh_new_ver} ] !"
        sleep 5s
        start_menu
    fi
}

check_docker() {
	if [ -x "$(command -v docker)" ]; then
		blue "docker is installed"
		# command
	else
		echo "Install docker"
		# command
		install_docker
	fi
}

install_docker(){
       curl -fsSL https://get.docker.com -o get-docker.sh  && \
       bash get-docker.sh
       service docker restart 
       systemctl enable docker
       bash ./node-install.sh
}

install_tool() {
    echo "===> Start to install tool"    
    if [ -x "$(command -v yum)" ]; then
        command -v curl > /dev/null || yum install -y curl
        systemctl stop firewalld.service
        systemctl disable firewalld.service
    elif [ -x "$(command -v apt)" ]; then
        command -v curl > /dev/null || apt install -y curl
    else
        echo "Package manager is not support this OS. Only support to use yum/apt."
        exit -1
    fi 
}

install_v2ray1(){

    clear
        echo "==============================================================="
        echo "程序：v2ray后端对接                    "
        echo "系统：Centos7.x、Ubuntu、Debian等                              "
        echo "==============================================================="
        echo
        green "Netflix解锁设置，示例：47.240.68.180 #【如果没有，可以联系TG:@DerrickZH购买】"
        echo
        echo ————————————选择v2ray安装版本————————————
        green "[1] Rico付费版"
        green "[2] Rico免费版"
        read -p "输入1或2进行选择:" opt
        echo " "

    if [[ ${opt} == [12] ]]; then

    clear

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

    if [ "$opt" = "1" ]; then
         install_tool
         check_docker
         docker run -d --name=$name -e speedtest=0 -e api_port=$api_port -e usemysql=1 -e downWithPanel=0 -e node_id=$node_id -e LDNS=$LDNS -e MYSQLHOST=$MYSQLHOST -e MYSQLDBNAME="$MYSQLDBNAME" -e MYSQLUSR="$MYSQLUSR" -e MYSQLPASSWD="$MYSQLPASSWD"  -e MYSQLPORT=3306 -e CF_Key=$CF_Key -e CF_Email=$CF_Email --log-opt max-size=10m --log-opt max-file=5 --network=host --restart=always bobkjl/v2ray:4.22.1.8

    else [ "$opt" = "2" ];
         install_tool
         check_docker
         docker run -d --name=$name -e speedtest=0 -e api_port=$api_port -e usemysql=1 -e downWithPanel=0 -e node_id=$node_id -e LDNS=$LDNS -e MYSQLHOST=$MYSQLHOST -e MYSQLDBNAME="$MYSQLDBNAME" -e MYSQLUSR="$MYSQLUSR" -e MYSQLPASSWD="$MYSQLPASSWD"  -e MYSQLPORT=3306 -e CF_Key=$CF_Key -e CF_Email=$CF_Email --log-opt max-size=10m --log-opt max-file=5 --network=host --restart=always bobkjl/v2ray_v3:go_pay

    fi

        echo -e "安装完成"

    else
        echo -e "输入错误，5秒后自动返回。"

        sleep 5s

        install_v2ray1
    fi

}

install_BBR(){
    wget "https://github.com/chiakge/Linux-NetSpeed/raw/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
}

install_superspeed(){
    bash <(curl -Lso- https://git.io/superspeed)
}

install_superbench(){
    wget https://raw.githubusercontent.com/oooldking/script/master/superbench.sh
    chmod +x superbench.sh
    ./superbench.sh
}

backend_docking_set(){
    white "本脚本支持 ${Green_font_prefix} webapi${Font_color_suffix} 和 ${Green_font_prefix} 数据库对接${Font_color_suffix} 两种对接方式"
    green "请选择对接方式(默认webapi)"
    yellow "[1] webapi对接(准备好域名就行)"
    yellow "[2] 数据库对接（需要提供完整的ip、数据库名、用户名、密码，且mysql要允许所有ip访问）"
    echo
    read -e -p "请输入数字[1~2](默认1)：" vnum
    [[ -z "${vnum}" ]] && vnum="1" 
	if [[ "${vnum}" == "1" ]]; then
        green "当前对接模式：webapi"
        green "使用前请准备好 ${Red_font_prefix}节点ID、前端网站ip或url、前端token${Font_color_suffix}"
        green "请输入网址，示例：https://google.com (网站域名，与config里的baseurl保持一致)"
        read -p "容器名字 参考格式 ssrmu，容器名同一服务器不能重复:" name
        read -p "请输入网址:" web_url
        green "请输入网站mukey(与config里的mukey保持一致):如未修改默认的NimaQu,可直接回车下一步"
        read -e -p "请输入mukey(默认值NimaQu)：" webapi_token
        [[ -z "${webapi_token}" ]] && webapi_token="NimaQu"
        green "节点ID,示例: 6"
        read -p "请输入节点ID:" node_id
        yellow "配置已完成，正在部署后端。。。。"
        start=$(date "+%s")
        install_tool
        check_docker
        docker run -d --name=$name -e NODE_ID=$node_id -e API_INTERFACE=modwebapi -e WEBAPI_URL=$web_url -e WEBAPI_TOKEN=$webapi_token --network=host --log-opt max-size=50m --log-opt max-file=3 --restart=always bobkjl/sspanel:ssr
        green "恭喜您，后端节点已搭建成功"
        end=$(date "+%s")
        echo 安装总耗时:$[$end-$start]"秒"           
	elif [[ "${vnum}" == "2" ]]; then
        green "当前对接模式：数据库对接"
        green "使用前请准备好 ${Red_font_prefix}节点ID、前端网站ip、数据库ROOT密码、数据库名称${Font_color_suffix}"
        green "请输入前端网网站IP，示例：23.94.13.115 (前端服务器IP地址)"
        read -p "容器名字 参考格式 ssrmu，容器名同一服务器不能重复:" name
        read -p "请输入ip:" web_ip
        green "节点ID：示例3"
        read -p "请输入节点ID:" node_id
        green "请输入数据库名（宝塔左侧、数据库、网站用的：数据库名）"
        read -p "请输入数据库名:" db_name
        green "请输入数据库用户名（宝塔左侧、数据库、网站用的：用户名）"
        read -p "请输入数据用户名:" db_user                        
        green "请输入前端网站数据库密码，（宝塔左侧、数据库、网站用的：密码）"
        read -p "请输入前端数据库密码:" user_pwd
        yellow "配置已完成，正在部署后端。。。。"
        start=$(date "+%s")
        install_tool
        check_docker
        docker run -d --name=$name -e NODE_ID=$node_id -e API_INTERFACE=glzjinmod -e MYSQL_HOST=$web_ip -e MYSQL_USER=$db_user -e MYSQL_DB=$db_name -e MYSQL_PASS=$user_pwd --network=host --log-opt max-size=50m --log-opt max-file=3 --restart=always bobkjl/sspanel:ssr
        green "恭喜您，后端节点已搭建成功"
        end=$(date "+%s")
        echo 安装总耗时:$[$end-$start]"秒"           
	fi       
}

backend_docking_netflix(){
    white "本脚本支持 ${Green_font_prefix} webapi${Font_color_suffix} 和 ${Green_font_prefix} 数据库对接${Font_color_suffix} 两种对接方式"
    green "请选择对接方式(默认webapi)"
    yellow "[1] webapi对接(准备好域名就行)"
    yellow "[2] 数据库对接（需要提供完整的ip、数据库名、用户名、密码，且mysql要允许所有ip访问）"
    echo
    read -e -p "请输入数字[1~2](默认1)：" vnum
    [[ -z "${vnum}" ]] && vnum="1" 
	if [[ "${vnum}" == "1" ]]; then
        green "当前对接模式：webapi"
        green "使用前请准备好 ${Red_font_prefix}节点ID、前端网站ip或url、前端token${Font_color_suffix}"
        green "请输入网址，示例：https://google.com (网站域名，与config里的baseurl保持一致)"
        read -p "请输入网址:" web_url
        red "Netflix解锁设置，示例：47.240.68.180 （如果没有，可回车，保留系统默认）"
        read -p "Netflix等流媒体解锁DNS:" dnsip
        [[ -z "${dnsip}" ]] && dnsip="8.8.8.8"         
        green "请输入网站mukey(与config里的mukey保持一致):如未修改默认的NimaQu,可直接回车下一步"
        read -e -p "请输入mukey(默认值NimaQu)：" webapi_token
        [[ -z "${webapi_token}" ]] && webapi_token="NimaQu"
        green "节点ID,示例: 6"
        read -p "请输入节点ID:" node_id
        yellow "配置已完成，正在部署后端。。。。"
        start=$(date "+%s")
        install_tool
        check_docker
        docker run -d --name=ssrmu -e NODE_ID=$node_id -e API_INTERFACE=modwebapi -e WEBAPI_URL=$web_url -e WEBAPI_TOKEN=$webapi_token -e DNS_1="$dnsip" -e DNS_2="" --network=host --log-opt max-size=50m --log-opt max-file=3 --restart=always bobkjl/sspanel:ssr
        green "恭喜您，后端节点已搭建成功"
        end=$(date "+%s")
        echo 安装总耗时:$[$end-$start]"秒"           
	elif [[ "${vnum}" == "2" ]]; then
        green "当前对接模式：数据库对接"
        green "使用前请准备好 ${Red_font_prefix}节点ID、前端网站ip、数据库ROOT密码、数据库名称${Font_color_suffix}"
        green "请输入前端网网站IP，示例：23.94.13.115 (前端服务器IP地址)"
        read -p "请输入ip:" web_ip
        red "Netflix解锁设置，示例：47.240.68.180 （如果没有，可回车，保留系统默认）"
        read -p "Netflix等流媒体解锁DNS:" dnsip
        [[ -z "${dnsip}" ]] && dnsip="8.8.8.8"          
        green "节点ID：示例3"
        read -p "请输入节点ID:" node_id        
        green "请输入数据库名（宝塔左侧、数据库、网站用的：数据库名）"
        read -p "请输入数据库名:" db_name
        green "请输入数据库用户名（宝塔左侧、数据库、网站用的：用户名）"
        read -p "请输入数据用户名:" db_user                        
        green "请输入前端网站数据库密码，（宝塔左侧、数据库、网站用的：密码）"
        read -p "请输入前端数据库密码:" user_pwd
        yellow "配置已完成，正在部署后端。。。。"
        start=$(date "+%s")
        install_tool
        check_docker
        docker run -d --name=ssrmu -e NODE_ID=$node_id -e API_INTERFACE=glzjinmod -e MYSQL_HOST=$web_ip -e MYSQL_USER=$db_user -e MYSQL_DB=$db_name -e MYSQL_PASS=$user_pwd -e DNS_1="$dnsip" -e DNS_2="" --network=host --log-opt max-size=50m --log-opt max-file=3 --restart=always bobkjl/sspanel:ssr
        green "恭喜您，后端节点已搭建成功"
        end=$(date "+%s")
        echo 安装总耗时:$[$end-$start]"秒"           
	fi       
}


install_ssr(){
    clear
    echo "==============================================================="
    echo "程序：sspanel后端对接                    "
    echo "系统：Centos7.x、Ubuntu、Debian等                              "
    echo "==============================================================="
    echo
    green "Netflix解锁设置，示例：47.240.68.180 #【如果没有，可以联系TG:@DerrickZH购买】"
    echo
    white "————————————程序安装（二选一）————————————"
    green "[1] SSPANEL后端对接（默认：支持SS\SSR）"
    green "[2] SSPANEL后端安装（Netflix等流媒体解锁版）"
    white "————————————杂项管理（此处3、4选项不适用）————————————"
    green "[3] 查看日志（故障查看、问题解决）"
    green "[4] 重启节点"
    green "[5] 卸载节点"
    white "————————————后端BBR加速————————————" 
    green "[6] 节点TCP加速（需要按情况自己调试，非必须）"
    green ""
    blue "[0] 退出脚本"
    echo
    echo
    read -p "请输入数字:" num

    case "$num" in
    1)
    echo "您选择了默认对接方式"
    backend_docking_set
	;;
    2)
    echo "您选择了默认的Netflix解锁对接"
    backend_docking_netflix
	;;
	3)
    read -p "请输入需要操作的Docker容器名:" name
    docker logs --tail 10 $name
    white "以下内容未提示信息"
    green "================================================================================="
    green "如果没有ERRO信息，则代表运行正常"
    white "正常情况示例："
    white "2019-07-18 07:38:42 INFO     server_pool.py:176 starting server at 0.0.0.0:49206"
    white "2019-07-18 07:38:42 WARNING  server_pool.py:190 IPV4 [Errno 98] Address in use "
    red "其它情况则检查前端设置或填写的域名ip是否正确"
    green "================================================================================="
	;;
	4)
    read -p "请输入需要操作的Docker容器名:" name
    docker restart $name
    green "节点已重启完毕"
	;;
	5)
    read -p "请输入需要操作的Docker容器名:" name
    red "正在卸载{$name}节点。。。"
    docker rm -f $name
	;;
	6)
    yellow "BBR加速"
    bash <(curl -L -s https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh)
	;;            
	0)
	exit 1
	;;
	*)
	clear
	echo "请输入正确数字[0~5],退出请按0"
	sleep 3s
	start_menu
	;;
    esac
}

start_menu(){
clear
    echo -e " sspanel 后端一键安装管理脚本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}"
    echo "###     sspanel node tool         ###"
    echo "###       By @DerrickZH           ###"
    echo "###     Update: 2020-04-03       ###"
    echo ""
    green "[0] 检查更新"
    echo ————————————Docker管理————————————
    green "[1] 安装Docker"
    echo ————————————后端管理————————————
    green "[2] 安装v2ray Rico版"
    green "[3] 安装ssr后端"
#   echo -e "[4] 捐赠开发者"
    echo ————————————服务器管理————————————
    green "[4] 安装TCP加速"
    green "[5] 服务器测速"
    green "[6] 服务器性能测试"
    echo "请输入选项以继续，ctrl+C退出"

    opt=0
     read opt
    if [ "$opt" = "1" ]; then
        install_docker

    elif [ "$opt" = "2" ]; then
        install_v2ray1
        
    elif [ "$opt" = "3" ]; then
        install_ssr

    elif [ "$opt" = "4" ]; then
        install_BBR
		
   elif [ "$opt" = "5" ]; then
        install_superspeed

    elif [ "$opt" = "6" ]; then
        install_superbench
        
    elif [ "$opt" = "0" ]; then
        Update
    
    else
        echo -e "输入错误"
        bash ./node-install.sh
    fi
}
start_menu
