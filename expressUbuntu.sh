#!/usr/bin/env bash

D=$PWD


# Create Swap for faster build
if [ ! -f /swapfile ]; then
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
sudo sh -c "echo '/swapfile none swap sw 0' >> /etc/fstab"
fi

# Get updates to Ubuntu
sudo apt-get update

# Open Sumcoin p2p and rpc ports
ufw allow 3333
ufw allow 3332

# Install needed Sumcoind essentials
sudo apt-get install \
      git -y \
      build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils -y \
      libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev -y \
      libboost-all-dev -y \
      software-properties-common -y \
      libdb4.8-dev libdb4.8++-dev -y \
      libminiupnpc-dev -y \
      libzmq3-dev -y \
      libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler -y \
      libqt4-dev libprotobuf-dev protobuf-compiler -y \
      sudo add-apt-repository ppa:bitcoin/bitcoin \


# Get new updates to Ubuntu
sudo apt-get update 
  

# Make .sumcoin data directory, touch sumcoin.conf, insert starter .conf
mkdir .sumcoin

# create sumcoin.conf
cat << EOF > .sumcoin/sumcoin.conf
server=1
daemon=1
deprecatedrpc=accounts
deprecatedrpc=estimatefee
rpcallowip=127.0.0.1
rpcbind=127.0.0.1:3332
txindex=1
rpcport=3332
maxconnections=100

# You will need to modify the CAPS portions below (!! Uncomment (#) the lines after completing - not THIS line though!!)
#rpcallowip=SERVER_IP_TO_YOUR_CAS

#rpcuser=YOUR_SECUREsumcoinusername
#rpcpassword=YOUR_SecurePassword


# Your CAS Connection String will be copied and pasted below INTO CAS - after making changes to string above

#  >>     http:YOUR_SECUREsumcoinusername:YOUR_SecurePassword:SERVER_IP_TO_YOUR_CAS:3332       <<
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
EOF

# install branch 17 Sumcoin
git clone -b 0.17 https://github.com/sumcoinlabs/sumcoin.git


# Build Sumcoin Ubuntu Client 
cd sumcoin
./autogen.sh
./configure --disable-tests --without-gui
make

# Copy Binaries to root
cd src
cp sumcoind ~/
cp sumcoin-cli ~/
cd ../..
./sumcoind

echo "Your Sumcoin Daemon Should Now Be Built and Server Starting"
echo "It may take several hours before your node is synced"
echo "You can run commands using ./sumcoin-cli"
echo "BE SURE TO BACKUP your wallet.dat file located in .sumcoin data directory"
echo "For assistance submit issue to https://github.com/sumcoinlabs/sumcoin/issues"
