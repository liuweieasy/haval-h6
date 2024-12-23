#!/bin/bash

# 定义颜色变量
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# 清屏函数
clear_screen() {
    clear
}

# 显示横幅
show_banner() {
    clear_screen
    echo -e "${BLUE}${BOLD}"
    echo "╔═══════════════════════════════════════════════════════════════════╗"
    echo "║                     EY DNS 服务器配置工具 v1.0                    ║"
    echo "╚═══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# 显示 IP 信息
show_ip_info() {
    echo -e "${YELLOW}╔═══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║${NC} 当前 IP 是：${GREEN}$IP${NC}"
    echo -e "${YELLOW}╚═══════════════════════════════════════════════════════════════════╝${NC}"
}

# 显示主菜单
show_main_menu() {
    echo -e "\n${CYAN}${BOLD}请选择要安装的工程模式：${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}1)${NC} 搭建${BOLD}安波福${NC}工程模式"
    echo -e "${GREEN}2)${NC} 搭建${BOLD}华阳${NC}工程模式"
    echo -e "${GREEN}3)${NC} 自定义软件"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# 显示 DNS 选择菜单
show_dns_menu() {
    echo -e "\n${CYAN}${BOLD}请选择 DNS 服务器类型：${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}1)${NC} 用 ${BOLD}dnsmasq${NC} 做 DNS 服务器"
    echo -e "${GREEN}2)${NC} 用 ${BOLD}bind${NC}    做 DNS 服务器"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# 显示状态信息
show_status() {
    local message="$1"
    local type="${2:-info}" # info, success, error, warning

    case $type in
        success)
            echo -e "${GREEN}✓ $message${NC}"
            ;;
        error)
            echo -e "${RED}✗ $message${NC}"
            ;;
        warning)
            echo -e "${YELLOW}⚠ $message${NC}"
            ;;
        *)
            echo -e "${BLUE}ℹ $message${NC}"
            ;;
    esac
}

# 显示横幅
show_banner

# 获取本机公网 IP 地址
IP=$(curl -s "https://ipinfo.io/ip" | tr -d '\n')
show_ip_info

# IP 确认
while true; do
    read -p "$(echo -e ${CYAN}"请确认 IP 是否正确(y/n)："${NC})" confirm
    if [[ "$confirm" =~ ^(y|Y|n|N)$ ]]; then
        break
    fi
    show_status "请输入 y 或 n" "warning"
done

if [[ "$confirm" =~ ^(y|Y)$ ]]; then
    show_status "IP 验证成功，继续下一步。" "success"
else
    while true; do
        read -p "$(echo -e ${CYAN}"请输入正确的 IP 地址："${NC})" IP
        if [[ $IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            break
        fi
        show_status "请输入正确的 IP 地址！" "error"
    done
    show_status "IP 验证成功，继续下一步。" "success"
fi

# 默认文件下载地址
abf_url="http://eycomm.us.kg:5288/d/UC/car/haval/files/AppStore/%E8%B0%83%E8%AF%95%E5%B7%A5%E5%85%B7/%E8%B0%83%E8%AF%952.0.apk"
hy_url="http://eycomm.us.kg:5288/d/UC/car/haval/files/AppStore/%E8%B0%83%E8%AF%95%E5%B7%A5%E5%85%B7/HYFactoryMode.apk"
index_url="http://eycomm.us.kg:5288/d/UC/%E6%9C%8D%E5%8A%A1%E5%99%A8/%20%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E9%83%A8%E7%BD%B2/windowsXP.html"
index_file=index.html
centos_repo="http://eycomm.us.kg:5288/d/UC/%E6%9C%8D%E5%8A%A1%E5%99%A8/%20%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E9%83%A8%E7%BD%B2/CentOS-Base(%E9%98%BF%E9%87%8C%E4%BA%91%E6%BA%90%EF%BC%89.repo"

# 显示主菜单
show_main_menu
read -p "$(echo -e ${CYAN}"请输入您的选择："${NC})" confirm

# 如果选择自定义下载地址
case $confirm in
    1) 
        show_status "您选择的是安波福工程模式" "info"
        apk_url=$abf_url
        type_name="安波福工程模式"
        apk_file="abf.apk"
        apk_msg="安波福车机"
		url="http://eycomm.us.kg:5288/d/UC/car/haval/files/AppStore/%E8%B0%83%E8%AF%95%E5%B7%A5%E5%85%B7/%E8%B0%83%E8%AF%952.0.apk"
        ;;
    2)
        show_status "您选择的是华阳工程模式" "info"
        apk_url=$hy_url
        type_name="华阳工程模式"
        apk_file="hy.apk"
        apk_msg="华阳车机"
		url="http://eycomm.us.kg:5288/d/UC/car/haval/files/AppStore/%E8%B0%83%E8%AF%95%E5%B7%A5%E5%85%B7/HYFactoryMode.apk"
        ;;
    3)
        read -p "$(echo -e ${CYAN}"请输入自定义的下载地址："${NC})" apk_url
        ;;
    *)
        show_status "输入无效，别瞎选，你要上天啊" "error"
        exit 1 
        ;;
esac

# 判断系统发行版本
if [ -f "/usr/bin/yum" ] && [ -d "/etc/yum.repos.d" ]; then
    PM="yum"
    echo "当前系统为 CentOS 环境"
    
    # 询问是否更换软件源
    read -p "$(echo -e ${CYAN}"是否要更换为阿里云软件源? (y/n)："${NC})" change_repo
    if [[ "$change_repo" =~ ^[Yy]$ ]]; then
        # CentOS 软件源更新
        if [ -f /etc/yum.repos.d/CentOS-Base.repo ]; then
            sudo cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
            echo "已备份 CentOS-Base.repo 到 CentOS-Base.repo.bak"
            
            sudo curl -o /etc/yum.repos.d/CentOS-Base.repo $centos_repo || {
                echo "下载 CentOS-Base.repo 失败"
                exit 1
            }
            echo "已成功下载并重命名 CentOS-Base.repo"
        fi
    fi
elif [ -f "/usr/bin/apt-get" ] && [ -f "/usr/bin/dpkg" ]; then
    PM="apt-get"
    echo "当前系统为 Ubuntu 环境"
    
    # 询问是否更换软件源
    read -p "$(echo -e ${CYAN}"是否要更换为阿里云软件源? (y/n)："${NC})" change_repo
    if [[ "$change_repo" =~ ^[Yy]$ ]]; then
        # Ubuntu 软件源更新
        # 备份原始源文件
        sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
        echo "已备份 sources.list 到 sources.list.bak"
        
        # 获取系统版本代号
        UBUNTU_CODENAME=$(lsb_release -cs)
        
        # 写入阿里云软件源
        sudo cat > /etc/apt/sources.list << EOF
deb http://mirrors.aliyun.com/ubuntu/ ${UBUNTU_CODENAME} main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ ${UBUNTU_CODENAME}-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ ${UBUNTU_CODENAME}-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ ${UBUNTU_CODENAME}-backports main restricted universe multiverse

deb-src http://mirrors.aliyun.com/ubuntu/ ${UBUNTU_CODENAME} main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ ${UBUNTU_CODENAME}-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ ${UBUNTU_CODENAME}-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ ${UBUNTU_CODENAME}-backports main restricted universe multiverse
EOF
        echo "已更新软件源为阿里云源"
    fi
fi

# 询问是否更新系统包
read -p "$(echo -e ${CYAN}"是否要更新系统包? (y/n)："${NC})" update_packages
if [[ "$update_packages" =~ ^[Yy]$ ]]; then
    show_status "正在更新系统包请稍后..." "info"
    sudo $PM -y update &> /dev/null || {
        show_status "系统包更新失败" "error"
        exit 1
    }
    show_status "系统包更新成功" "success"
fi

# 检查 netstat 是否已安装，如果没有则安装
if ! command -v netstat &> /dev/null; then
    echo "正在安装 netstat ..."
    $PM -y install net-tools > /dev/null 2>&1
    if ! command -v netstat &> /dev/null; then
        echo "安装 netstat 失败，请检查网络和配置。"
        exit 1
    fi
fi

# 显示 DNS 选择菜单
show_dns_menu
read -p "$(echo -e ${CYAN}"请选择 DNS 服务器类型："${NC})" dns_choice

# 安装 dnsmasq 或 bind
case $dns_choice in
    1)
        echo "选择 dnsmasq 作为 DNS 服务器"
        systemctl stop systemd-resolved > /dev/null 2>&1
        echo "开始安装 dnsmasq"

        netstat -tuln | grep ":53 " > /dev/null
        if [ $? -eq 0 ]; then
            echo "端口 53 已被占用，dnsmasq 安装或启动可能失败"
        fi

        if [[ $(systemctl is-active dnsmasq) != "active" ]]; then
            echo "正在安装 dnsmasq ..."
            $PM -y install dnsmasq > /dev/null 2>&1
            systemctl start dnsmasq

            if [[ $(systemctl is-active dnsmasq) != "active" ]]; then
                echo "安装 dnsmasq 失败，请检查网络和配置。"
                exit 1
            fi

            systemctl enable dnsmasq > /dev/null 2>&1
            echo "dnsmasq 安装成功。"
        else
            echo "dnsmasq 已经安装，跳过安装步骤。"
        fi

        # 配置 dnsmasq
        cat << EOF > /etc/dnsmasq.conf
address=/qq.com/$IP
address=/gwm.com.cn/$IP
listen-address=$IP
# resolv-file=/etc/dnsmasq.resolv.conf
# addn-hosts=/etc/dnsmasq.hosts
interface=$(ip route | awk '/default/ {print $5}')
log-queries
EOF

        systemctl restart dnsmasq
        ;;
    2)
        echo "选择 bind 作为 DNS 服务器"
        systemctl stop systemd-resolved > /dev/null 2>&1
        echo "开始安装 bind"

        netstat -tuln | grep ":53 " > /dev/null
        if [ $? -eq 0 ]; then
            echo "端口 53 已被占用，bind 安装或启动可能失败"
        fi

        if [[ $(systemctl is-active named) != "active" ]]; then
            echo "正在安装 bind ..."
            $PM -y install bind > /dev/null 2>&1
            systemctl start named

            if [[ $(systemctl is-active named) != "active" ]]; then
                echo "安装 bind 失败，请检查网络和配置。"
                exit 1
            fi

            systemctl enable named > /dev/null 2>&1
            echo "bind 安装成功。"
        else
            echo "bind 已经安装，跳过安装步骤。"
        fi

        # 配置 bind 主文件
        cat << EOF > /etc/named.conf
//
// named.conf
//
// Provided by Red Hat bind package to configure the ISC BIND named(8) DNS
// server as a caching only nameserver (as a localhost DNS resolver only).
//
// See /usr/share/doc/bind*/sample/ for example named configuration files.
//
// See the BIND Administrator's Reference Manual (ARM) for details about the
// configuration located in /usr/share/doc/bind-{version}/Bv9ARM.html

options {
	listen-on port 53 { any; };
	listen-on-v6 port 53 { ::1; };
	directory 	"/var/named";
	dump-file 	"/var/named/data/cache_dump.db";
	statistics-file "/var/named/data/named_stats.txt";
	memstatistics-file "/var/named/data/named_mem_stats.txt";
	recursing-file  "/var/named/data/named.recursing";
	secroots-file   "/var/named/data/named.secroots";
	allow-query     { any; };

	/* 
	 - If you are building an AUTHORITATIVE DNS server, do NOT enable recursion.
	 - If you are building a RECURSIVE (caching) DNS server, you need to enable 
	   recursion. 
	 - If your recursive DNS server has a public IP address, you MUST enable access 
	   control to limit queries to your legitimate users. Failing to do so will
	   cause your server to become part of large scale DNS amplification 
	   attacks. Implementing BCP38 within your network would greatly
	   reduce such attack surface 
	*/
	recursion yes;

	dnssec-enable yes;
	dnssec-validation yes;

	/* Path to ISC DLV key */
	bindkeys-file "/etc/named.root.key";

	managed-keys-directory "/var/named/dynamic";

	pid-file "/run/named/named.pid";
	session-keyfile "/run/named/session.key";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

zone "." IN {
	type hint;
	file "named.ca";
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";

EOF

        # 配置bind区域文件
        cat << EOF > /etc/named.rfc1912.zones
// named.rfc1912.zones:
//
// Provided by Red Hat caching-nameserver package 
//
// ISC BIND named zone configuration for zones recommended by
// RFC 1912 section 4.1 : localhost TLDs and address zones
// and http://www.ietf.org/internet-drafts/draft-ietf-dnsop-default-local-zones-02.txt
// (c)2007 R W Franks
// 
// See /usr/share/doc/bind*/sample/ for example named configuration files.
//

zone "localhost.localdomain" IN {
	type master;
	file "named.localhost";
	allow-update { none; };
};

zone "localhost" IN {
	type master;
	file "named.localhost";
	allow-update { none; };
};

zone "1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa" IN {
	type master;
	file "named.loopback";
	allow-update { none; };
};

zone "1.0.0.127.in-addr.arpa" IN {
	type master;
	file "named.loopback";
	allow-update { none; };
};

zone "0.in-addr.arpa" IN {
	type master;
	file "named.empty";
	allow-update { none; };
};

zone "gwm.com.cn" IN {
	type master;
	file "gwm.com.cn.zone";
	allow-update { none; };
};

EOF

        cd /var/named/
        cp -a named.localhost gwm.com.cn.zone

        # 配置bind区域数据文件
cat << EOF > /var/named/gwm.com.cn.zone
\$TTL 604800
@   IN  SOA  gwm.com.cn. root.gwm.com.cn.zone. (
               2024080100 ; Serial
               604800     ; Refresh
               86400      ; Retry
               2419200    ; Expire
               604800 )   ; Minimum

        IN  NS      dns
dns     IN  A       $IP
dzsms   IN  A       $IP

EOF

        systemctl start named
        systemctl restart named
        ;;
    *)
        echo "输入无效，别瞎选，你要上天啊"
        exit 1
        ;;
esac

# 安装 nginx
if [[ $(systemctl is-active nginx) != "active" ]]; then
    echo "正在安装 nginx ..."
    $PM -y install epel-release > /dev/null 2>&1
    $PM -y install nginx > /dev/null 2>&1
    mkdir /etc/nginx/cert

    systemctl start nginx

    if [[ $(systemctl is-active nginx) != "active" ]]; then
        echo "安装 nginx 失败，请检查网络和配置。"
        exit 1
    fi

    systemctl enable nginx > /dev/null 2>&1
    echo "nginx 已经安装并启动成功。"
else
    echo "nginx 已经安装，跳过安装步骤。"
fi

# 下载 APK 文件
mkdir -p /usr/share/nginx/html

# 下载 index 文件
wget -O /usr/share/nginx/html/$index_file $index_url &>/dev/null

# 检查并下载 APK 文件
if [[ "$confirm" == "1" ]]; then
    if [ ! -f "/usr/share/nginx/html/$apk_file" ] || [ ! -s "/usr/share/nginx/html/$apk_file" ]; then
        show_status "正在下载安波福调试模式工具..." "info"
        wget -O /usr/share/nginx/html/$apk_file $abf_url &>/dev/null
    else
        show_status "安波福调试模式工具已存在，跳过下载" "info"
    fi
elif [[ "$confirm" == "2" ]]; then
    if [ ! -f "/usr/share/nginx/html/$apk_file" ] || [ ! -s "/usr/share/nginx/html/$apk_file" ]; then
        show_status "正在下载华阳工程模式工具..." "info"
        wget -O /usr/share/nginx/html/$apk_file $hy_url &>/dev/null
    else
        show_status "华阳工程模式工具已存在，跳过下载" "info"
    fi
fi

# 生成 SSL 证书
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 \
  -subj "/C=CN/ST=Beijing/L=Beijing/O=MyOrg/OU=MyUnit/CN=$IP" \
  -keyout /etc/nginx/cert/server.key -out /etc/nginx/cert/server.crt > /dev/null 2>&1

# 配置 hosts
cat << EOF > /etc/hosts
$IP dzsms.gwm.com.cn
EOF

# 配置 nginx
cat << EOF > /etc/nginx/nginx.conf
worker_processes 1;
events {
  worker_connections 1024;
}
http {
    include mime.types;
    default_type application/octet-stream;
    sendfile on;
    keepalive_timeout 65;
    server {
        listen 443 ssl;
        listen 80;
        server_name $IP;
        ssl_certificate /etc/nginx/cert/server.crt;
        ssl_certificate_key /etc/nginx/cert/server.key;
        ssl_session_timeout 5m;
        ssl_ciphers HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers on;
     
        location / {
            root /usr/share/nginx/html/;
            index index.html index.htm;
        }

        location /apiv2/car_apk_update {
            default_type application/json;
            return 200 '{
                "code": 200,
                "message": "\u67e5\u8be2\u6210\u529f",
                "data": {
                    "apk_version": "99999",
                    "apk_url": "$url",
                    "apk_msg": "注意:使用本软件存在风险，$apk_msg用户需自行承担因使用软件而产生的任何后果，作者不承担任何责任。",
                    "isUpdate": "Yes",
                    "apk_forceUpdate": "Yes",
                    "notice": {
                        "vin_notice": [
                            "VIN码可以在仪表板左上方（前风挡玻璃后面）和车辆铭牌上获得。",
                            "本应用适用于2019年及之后生产的车型。"
                        ],
                        "add_notice": [
                            "制造年月可通过车辆铭牌获得。",
                            "本应用适用于2019年及之后生产的车型。"
                        ]
                    },
                    "notice_en": {
                        "vin_notice": [],
                        "add_notice": [
                            "The date can be obtained from the certification label."
                        ]
                    }
                }
            }';
        }

    }
}
EOF

if [ $? -eq 0 ]; then
    echo "nginx配置写入成功"
else
    echo "nginx配置写入失败，请手动写入"
fi

systemctl restart nginx

if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}${BOLD}╔═══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}${BOLD}║                         安装部署成功！                            ║${NC}"
    echo -e "${GREEN}${BOLD}╚═══════════════════════════════════════════════════════════════════╝${NC}"
    
    echo -e "\n${CYAN}${BOLD}服务器信息：${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${BOLD}DNS 服务器IP:${NC}  ${GREEN}$IP${NC}"
    echo -e "  ${BOLD}安装类型:${NC}      ${GREEN}$type_name${NC}"
    echo -e "  ${BOLD}服务状态:${NC}      ${GREEN}运行中${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    echo -e "\n${CYAN}${BOLD}注意事项：${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${RED}• 请确保在防火墙中放行以下端口：${NC}"
    echo -e "   ${BOLD}- DNS 服务端口:${NC} ${PURPLE}53${NC} (TCP/UDP)"
    echo -e "   ${BOLD}- HTTP    端口:${NC} ${PURPLE}80${NC}"
    echo -e "   ${BOLD}- HTTPS   端口:${NC} ${PURPLE}443${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    echo -e "\n${CYAN}${BOLD}服务访问：${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${BOLD}Web 访问地址:${NC} ${GREEN}https://$IP${NC}"
    echo -e "  ${BOLD}DNS 解析地址:${NC} ${GREEN}$IP${NC}"
    echo -e "  ${BOLD}服务状态:${NC}     ${GREEN}运行中${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    

    # 添加服务控制菜单
    echo -e "\n${CYAN}${BOLD}服务控制：${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p "$(echo -e ${CYAN}"是否立即启动 DNS 服务器？(y/n)："${NC})" start_service

    if [[ "$start_service" =~ ^[Nn]$ ]]; then
        # 停止服务
        if [[ "$dns_choice" == "1" ]]; then
            systemctl stop dnsmasq
            systemctl stop nginx
            show_status "已停止 DNS 和 Web 服务" "info"
            
            echo -e "\n${YELLOW}${BOLD}服务已停止！您可以稍后手动启动服务：${NC}"
            echo -e "  ${BOLD}启动 DNS 服务：${NC}${GREEN}systemctl start dnsmasq${NC}"
            echo -e "  ${BOLD}启动 Web 服务：${NC}${GREEN}systemctl start nginx${NC}"
        elif [[ "$dns_choice" == "2" ]]; then
            systemctl stop named
            systemctl stop nginx
            show_status "已停止 DNS 和 Web 服务" "info"
            
            echo -e "\n${YELLOW}${BOLD}服务已停止！您可以稍后手动启动服务：${NC}"
            echo -e "  ${BOLD}启动 DNS 服务：${NC}${GREEN}systemctl start named${NC}"
            echo -e "  ${BOLD}启动 Web 服务：${NC}${GREEN}systemctl start nginx${NC}"
        fi
    else
        if [[ "$dns_choice" == "1" ]]; then
            show_status "DNS 和 Web 服务器保持运行状态" "success"
        elif [[ "$dns_choice" == "2" ]]; then
            show_status "DNS 和 Web 服务器保持运行状态" "success"
        fi
    fi
else
    echo -e "\n${RED}${BOLD}╔═══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}${BOLD}║                         安装部署失败！                            ║${NC}"
    echo -e "${RED}${BOLD}╚═══════════════════════════════════════════════════════════════════╝${NC}"
    
    echo -e "\n${CYAN}${BOLD}错误信息：${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${RED}• nginx 启动失败，请检查以下内容：${NC}"
    echo -e "    ${BOLD}- nginx 配置文件是否正确${NC}"
    echo -e "    ${BOLD}- 端口 80 和 443 是否被占用${NC}"
    echo -e "    ${BOLD}- 系统日志中的错误信息${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    echo -e "\n${RED}${BOLD}请解决以上问题后重新运行脚本！${NC}\n"
fi

# 计算总用时
    total_time=${SECONDS}
    minutes=$((total_time / 60))
    seconds=$((total_time % 60))
    
    echo -e "\n${CYAN}${BOLD}安装用时：${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${BOLD}总计用时: ${NC}${GREEN}${minutes} 分 ${seconds} 秒${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "\n${GREEN}${BOLD}安装部署已完成，祝您使用愉快！${NC}\n"
# 执行清除客户端根目录删除shell脚本文件
# 获取当前日期和时间
current_date=$(date)
 
# 将结果写入文件
echo "$current_date" > result.txt
 
# 执行你的其他操作...
 
# 删除脚本本身和结果文件
rm -f $0 result.txt