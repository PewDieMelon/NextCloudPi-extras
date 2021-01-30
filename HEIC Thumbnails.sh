#!/bin/bash

########################
# install dependencies #
########################

sudo sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
sudo apt update
sudo apt install -y build-essential autoconf libtool git-core

###################################
# compile the codecs and software #
###################################

cd /usr/src/ 
sudo git clone https://github.com/strukturag/libde265.git  
sudo git clone https://github.com/strukturag/libheif.git 
cd libde265/ 
sudo ./autogen.sh 
sudo ./configure 
sudo make  
sudo make install 
cd /usr/src/libheif/ 
sudo ./autogen.sh 
sudo ./configure 
sudo make  
sudo make install 
cd /usr/src/ 
sudo wget https://www.imagemagick.org/download/ImageMagick.tar.gz 
sudo tar xf ImageMagick.tar.gz 
cd ImageMagick-7*
sudo ./configure --with-heic=yes 
sudo make  
sudo make install  
sudo ldconfig

#######################
# activate PHP plugin #
#######################

sudo phpize
sudo phpenmod imagick
sudo systemctl restart apache2

###################################
# check if it is set up correctly #
###################################

sudo php -r 'phpinfo();' | grep HEIC

#################################################
# if HEIC is highlighted in the output, you are #
# good to go                                    #
#################################################

sudo reboot
