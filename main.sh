#!/bin/sh
rm -rf wgcf.conf
rm -rf files.zip
clear
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
PLAIN='\033[0m'

red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}

green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}

yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}

rm -f warp.conf proxy.conf

chmod +x ./warp-go
clear
yellow "==================================="
yellow " WARP ACCOUNT GENERATOR BY MISAKA"
yellow "                  Translate by MD"
yellow "==================================="
yellow "Please select the type of WARP account "
echo ""
echo -e " ${GREEN}1.${PLAIN} WARP wgcf free account ${YELLOW}(default)${PLAIN}"
echo -e " ${GREEN}2.${PLAIN} WARP+"
echo -e " ${GREEN}3.${PLAIN} WARP Teams"
echo ""
read -p "Please enter options [1-3]: " account_type
if [[ $account_type == 2 ]]; then
  yellow "How to obtain CloudFlare WARP account key information: "
  green "Computer: Download and install CloudFlare WARP → Settings → Preferences → Accounts → Copy key into script"
  green "Mobile: Download and install 1.1.1.1 APP → Menu → Account → Copy the key to the script"
  echo ""
  yellow "Important: Please make sure the account status of the 1.1.1.1 APP on your phone or computer is WARP+!"
  echo ""
read -rp "Enter WARP account license key (26 characters): " warpkey
  until [[ $warpkey =~ ^[A-Z0-9a-z]{8}-[A-Z0-9a-z]{8}-[A-Z0-9a-z]{8}$ ]]; do
    red "WARP account license key format input error, please re-enter!"
    read -rp "Enter WARP account license key (26 characters): " warpkey
  done
  read -rp "Please enter a custom device name, if not entered, the default random device name will be used: " device_name
  [[ -z $device_name ]] && device_name=$(date +%s%N | md5sum | cut -c 1-6)

  wget https://api.zeroteam.top/warp?format=warp-go -O warp.conf && chmod +x warp.conf 
  ./warp-go --update --config=./warp.conf --license=$warpkey --device-name=$device_name
elif [[ $account_type == 3 ]]; then
yellow "Please get your WARP Teams account TOKEN from this website: https://web--public--warp-team-api--coia-mfs4.code.run/"
  read -rp "Please enter the TOKEN of your WARP Teams account:" teams_token
  if [[ -n $teams_token ]]; then
    read -rp "Please enter a custom device name, if not entered, the default random device name will be used: " device_name
    [[ -z $device_name ]] && device_name=$(date +%s%N | md5sum | cut -c 1-6)
    
    wget https://api.zeroteam.top/warp?format=warp-go -O warp.conf && chmod +x warp.conf 
    ./warp-go --update --config=warp.conf --team-config=$teams_token --device-name=$device_name
  else
    red "The WARP Teams account TOKEN was not entered, the script exited!"
    exit 1
  fi
else
  wget https://api.zeroteam.top/warp?format=warp-go -O warp.conf && chmod +x warp.conf
fi

./warp-go --config=warp.conf --export-wireguard=proxy.conf


green "WireGuard configuration file for WARP-GO successfully generated!"
yellow "The following is the content of the configuration file:"
red "$(cat proxy.conf)"
echo ""
yellow "The following is the configuration file sharing QR code:"
qrencode -t ansiutf8 < proxy.conf
echo ""
yellow "The following is the content of the configuration file:"
cat proxy.conf > wgcf.conf
echo ""
yellow "Please download the configuration file:"
yellow "https://raw.githubusercontent.com/mdxscript/wgcfxx/main/warp.conf"