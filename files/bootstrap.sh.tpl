#!/bin/bash

set -e

function installDependencies() {
  echo "deb http://deb.debian.org/debian buster-backports main" | sudo tee -a "/etc/apt/sources.list.d/backports.list" > /dev/null
  sudo apt-get -qq update &>/dev/null
  sudo apt-get -yqq install linux-headers-$(uname -r)
  sudo apt-get -yqq install git autotools-dev cdbs debhelper dh-autoreconf dpkg-dev gettext libev-dev libpcre3-dev libudns-dev pkg-config fakeroot devscripts wireguard-dkms &>/dev/null
}

function addSSHKeys () {
  echo "Adding SSH Keys..."

  mkdir -p /home/${user}/.ssh
  touch /home/${user}/.ssh/authorized_keys

  %{ for key in ssh_keys ~}
  sudo tee -a /home/${user}/.ssh/authorized_keys <<EOF
${key}
EOF
  %{ endfor ~}
}

function addWG() {
  echo "Adding WireGuard configuration...."
  sudo tee /etc/wireguard/wg0.conf > /dev/null <<"EOF"
${wg_conf}
EOF
}

function buildSniProxy() {
  echo "Building sniproxy...."
  mkdir -p /usr/local/src/sniproxy
  git clone https://github.com/dlundquist/sniproxy.git /usr/local/src/sniproxy/git_src 
  cd /usr/local/src/sniproxy/git_src
  git checkout 822bb80
  git reset --hard 822bb80
  ./autogen.sh && ./configure && make
}

function installSniProxy() {
  echo "Installing sniproxy...."
  sudo mkdir -p /var/log/sniproxy
  sudo cp /usr/local/src/sniproxy/git_src/src/sniproxy /usr/sbin
  
  sudo tee /etc/sniproxy.conf > /dev/null <<"EOF"
${sniproxy_conf}
EOF

  sudo chown daemon:daemon /usr/sbin/sniproxy
  sudo chown daemon:daemon /etc/sniproxy.conf
  sudo setcap CAP_NET_BIND_SERVICE=+eip /usr/sbin/sniproxy

  sudo tee /etc/systemd/system/sniproxy.service > /dev/null <<"EOF"
${sniproxy_service}
EOF
}

function loadServices() {
  echo "Starting services..."
  sudo systemctl daemon-reload
  sudo systemctl enable sniproxy wg-quick@wg0 ssh || true
  sudo systemctl restart sniproxy wg-quick@wg0 || true
}

addSSHKeys
installDependencies
buildSniProxy
installSniProxy
addWG
loadServices