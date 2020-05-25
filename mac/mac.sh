#!/bin/bash
# 先下載可愛崩崩 dnsproxy

get_latest_release() {
  curl --silent "https://api.github.com/repos/AdguardTeam/dnsproxy/releases/latest" |
    grep '"tag_name":' |
    sed -E 's/.*"([^"]+)".*/\1/'
}


# 開始執行
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# printf "I ${RED}love${NC} Stack Overflow\n"
echo -e "${GREEN}[info]${NC} 獲取最新 dnsproxy 版本中 ..."
version=$(get_latest_release)

echo -e "${GREEN}[info]${NC} 正在下載 dnsproxy ${version} ..."
curl -o "./dnsproxy-darwin-amd64-${version}.tar.gz" -fL "https://github.com/AdguardTeam/dnsproxy/releases/download/${version}/dnsproxy-darwin-amd64-${version}.tar.gz"

echo -e "${GREEN}[info]${NC} 解壓縮..."
tar zxvf "dnsproxy-darwin-amd64-${version}.tar.gz"

echo -e "${GREEN}[info]${NC} 下載設定..."
curl -o "./com.adguardteam.dnsproxy.plist" -fL "https://futaguard.github.io/Public-DNS/mac/com.adguardteam.dnsproxy.plist"

echo -e "\n=====\n"

echo -e "${RED}需輸入完整路徑！！！${NC}"
read -p "請輸入主要 DoT 伺服器位置（預設 tls://dns.adguard.com）：`echo $'\n> '`" dot1
read -p "請輸入次要 DoT 伺服器位置（預設 tls://dns.google）：`echo $'\n> '`" dot2

if [ "${dot1}}" != "" ] ; then
  sed -i '' "s+tls://dns.adguard.com+${dot1}+g" "com.adguardteam.dnsproxy.plist"
fi

if [ "${dot2}" != "" ] ; then
  sed -i '' "s+tls://dns.google+${dot2}+g" "com.adguardteam.dnsproxy.plist"
fi

# 壞壞的操作。
# sudo -s
sudo cp ./darwin-amd64/dnsproxy /usr/local/bin/
sudo cp ./com.adguardteam.dnsproxy.plist /Library/LaunchDaemons
sudo launchctl load -w /Library/LaunchDaemons/com.adguardteam.dnsproxy.plist

# 自己的大便自己掃
rm -rf darwin-amd64 dnsproxy-darwin-amd64-v0.28.1.tar.gz