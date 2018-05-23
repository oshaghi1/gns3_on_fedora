#!/bin/bash
#=================== Start ===========================#
# Check if the script is being run by root
if [ "$(id -u)" != "0" ]; then
	echo "This scripts must be run as root" 1>&2
	exit 1
fi

# you shoud update your fedora manually
# Update system
# dnf -y update

# Install dnf packages
dnf -y install gns3-server gns3-gui.noarch gcc cmake elfutils-libelf-devel libuuid-devel libpcap-devel python3-devel redhat-rpm-config python3-qt5 python3-sip glibc-static xterm wget git bison flex docker tigervnc wireshark-qt elfutils-libelf-devel libpcap-devel glibc-devel.i686 elfutils-devel.i686 libpcap-devel.i686

#======================dynamips========================#
# Create a temporary folder on /tmp
mkdir -p /tmp/build-dynamips
cd /tmp/build-dynamips

git clone git://github.com/GNS3/dynamips.git
cd dynamips/
mkdir build
cd build
cmake .. -DDYNAMIPS_ARCH=x86
make install

# Remove folder
rm -rf /tmp/build-dynamips

#======================iouyap========================#

cd /tmp
git clone http://github.com/ndevilla/iniparser.git
cd iniparser
make
sudo cp libiniparser.* /usr/lib/
sudo cp src/iniparser.h /usr/local/include
sudo cp src/dictionary.h /usr/local/include
cd ..

git clone https://github.com/GNS3/iouyap.git
cd iouyap
make
sudo make install

#=======================================#
cd /tmp
git clone git://github.com/GNS3/ubridge.git
cd ubridge
make
make install
ls -lash /usr/local/bin/ubridge

#=====================vpcs==================#

dnf copr enable athmane/gns3-extra -y
dnf install vpcs -y

#=====================display to user==================#

echo " GNS3 Installation script finished          "
echo " VPCS Install directory: /opt/vpcs/src/vpcs     "
echo " newgrp docker "
echo " groupadd docker && sudo gpasswd -a ${USER} docker && sudo systemctl restart docker"
echo " sudo usermod -a -G wireshark ${USER} "
