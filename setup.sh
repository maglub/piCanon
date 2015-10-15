
this_dir=$(cd `dirname $0`; pwd);
. $this_dir/etc/piCanon.conf

[ -z "$configDir" ] && configDir=$this_dir/etc

#=======================================
# Install lighttpd
#=======================================

sudo dpkg -s lighttpd >/dev/null 2>&1 || { echo "  - Installing lighttpd" ; sudo apt-get -y install lighttpd ; }

[ -f /etc/lighttpd/lighttpd.conf ]  && { sudo mv /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf.org ; }
[ ! -f /etc/lighttpd/lighttpd.conf ]  && { sudo ln -s $configDir/lighttpd/lighttpd.conf /etc/lighttpd ; }
[ ! -h /etc/lighttpd/conf-enabled/10-accesslog.conf ] && sudo ln -s $configDir/lighttpd/conf-enabled/10-accesslog.conf /etc/lighttpd/conf-enabled
[ ! -h /etc/lighttpd/conf-enabled/10-dir-listing.conf ] && sudo ln -s $configDir/lighttpd/conf-enabled/10-dir-listing.conf /etc/lighttpd/conf-enabled
[ ! -h /etc/lighttpd/conf-enabled/10-cgi.conf ] && sudo ln -s $configDir/lighttpd/conf-enabled/10-cgi.conf /etc/lighttpd/conf-enabled

sudo service lighttpd restart

#=======================================
# Packages
#=======================================

for package in gphoto2 php5 php5-sqlite php5-cgi php5-cli php5-rrd perlmagick imagemagick screen
do
  sudo dpkg -s $package >/dev/null 2>&1 || { echo "  - Installing $package" ; sudo apt-get -y install $package; }
done

#=======================================
# Link save directory
#=======================================
ln -fs $baseDir/save $baseDir/html/save

#=======================================
# composer
#=======================================

cd $this_dir/include
curl -s https://getcomposer.org/installer | php
./composer.phar install
cd -

