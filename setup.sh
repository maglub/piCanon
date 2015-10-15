#!/bin/bash

this_dir=$(cd `dirname $0`; pwd);

echo "* Setup will check for required components and set up your raspberry pi"

[ ! -f $this_dir/config/piSnapper.conf ] && { echo "Copying the config/piSnapper.conf.template to config/piSnapper.conf" ; cp $this_dir/config/piSnapper.conf.template $this_dir/config/piSnapper.conf ; }

. $this_dir/config/piSnapper.conf

[ -z "$configDir" ] && configDir=$this_dir/config

#=======================================
# Install lighttpd
#=======================================

echo "  - Checking for lighttpd"
sudo dpkg -s lighttpd >/dev/null 2>&1 || { echo "    - Installing lighttpd" ; sudo apt-get -y install lighttpd ; }

echo "  - Setting up lighttpd configuration files"
[ -f /etc/lighttpd/lighttpd.conf ]  && { echo "    - saving old lighttpd.conf" ; sudo mv /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf.org ; }
[ ! -f /etc/lighttpd/lighttpd.conf ]  && { echo "    - symlinking lighttpd.conf" ; sudo ln -s $configDir/etc/lighttpd/lighttpd.conf /etc/lighttpd ; }
[ ! -h /etc/lighttpd/conf-enabled/10-accesslog.conf ] && { echo "    - adding accesslog configuration" ; sudo ln -s $configDir/etc/lighttpd/conf-enabled/10-accesslog.conf /etc/lighttpd/conf-enabled ; }
[ ! -h /etc/lighttpd/conf-enabled/10-dir-listing.conf ] && { echo "    - adding directory listing configuration" ; sudo ln -s $configDir/etc/lighttpd/conf-enabled/10-dir-listing.conf /etc/lighttpd/conf-enabled ; }
[ ! -h /etc/lighttpd/conf-enabled/10-cgi.conf ] && { echo "    - adding cgi configuration" ; sudo ln -s $configDir/etc/lighttpd/conf-enabled/10-cgi.conf /etc/lighttpd/conf-enabled ; }


echo "  - Restarting lighttpd"
sudo service lighttpd restart

#=======================================
# Packages
#=======================================

for package in gphoto2 php5 php5-sqlite php5-cgi php5-cli php5-rrd perlmagick imagemagick screen
do
  echo "  - Checking for package $package"
  sudo dpkg -s $package >/dev/null 2>&1 || { echo "    - Installing $package" ; sudo apt-get -y install $package; }
done

#=======================================
# Link save directory
#=======================================
echo "  - Setting up the save directory symlink into the html directory"
ln -fs $baseDir/save $baseDir/html/save

#=======================================
# composer
#=======================================

echo "  - Setting up composer"
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
cd $this_dir/include
composer install
cd -

#=======================================
# Setup sudoers
#=======================================
echo "  - Setting up /etc/sudoers.d"
sudo cp $configDir/etc/sudoers.d/piSnapper /etc/sudoers.d/piSnapper ; sudo chown root:root /etc/sudoers.d/piSnapper ; sudo chmod 0440 /etc/sudoers.d/piSnapper 

