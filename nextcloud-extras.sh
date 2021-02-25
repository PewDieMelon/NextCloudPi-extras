#############################################################################
# As of writing, the NextCloudPi image was last updated on 30.11.2020 and   #
# has some problems right out of the box. This script is optimized for this #
# exact release only!                                                       #
#############################################################################

# First make sure everything is up to date #

sudo apt update && sudo apt full-upgrade -y && sudo ncp-update

# Now the drive needs to be set up correctly #

# Complete setup in the setup wizard: http://nextcloudpi.local/activate/ and navigate to the ncp configuration panel

sudo mkdir /media/myCloudDrive/ncdatabase

# Go to nc-datadir https://nextcloudpi.local:4443/?app=nc-datadir and replace /media/USBdrive/ncdata with /media/myCloudDrive/ncdata

# Go to nc-database https://nextcloudpi.local:4443/?app=nc-database and replace /media/USBdrive/ncdatabase with /media/myCloudDrive/ncdatabase

# The following is for virus protection #

# Now install antivirus for files from the NC app store https://nextcloudpi.local/index.php/settings/apps/security/files_antivirus

sudo apt install -y clamav clamav-daemon
sudo systemctl stop clamd
sudo systemctl stop clamav-freshclam
sudo freshclam
sudo systemctl start clamav-freshclam
sudo systemctl start clamav-daemon

# Now you should be able to activate the ClamAV-Daemon (Socket) option in the settings https://nextcloudpi.local/index.php/settings/admin/security



#############################################################################
# This part is for enabling previews of HEIF images. If you don't use an    #
# iDevice you can probably skip this part.                                  #
#############################################################################

# Install dependencies #

sudo sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
sudo apt update
sudo apt install -y build-essential autoconf libtool git-core

# Compile the codecs and software #

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

# activate PHP plugin #

sudo phpize
sudo phpenmod imagick
sudo systemctl restart apache2

# check if it is set up correctly #

sudo php -r 'phpinfo();' | grep HEIC

# if HEIC is highlighted in the output, you are #
# good to go                                    #

sudo reboot


