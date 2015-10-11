
this_dir=$(cd `dirname $0`; pwd);
. $this_dir/etc/piCanon.conf

[ -z "$configDir" ] && configDir=$this_dir/etc

#=======================================
# Install gphoto2
#=======================================
sudo dpkg -s gphoto2 >/dev/null 2>&1 || { echo "  - Installing gphoto2" ; sudo apt-get -y install gphoto2 ; }

#=======================================
# Install lighttpd
#=======================================

sudo dpkg -s lighttpd >/dev/null 2>&1 || { echo "  - Installing lighttpd" ; sudo apt-get -y install lighttpd ; }

[ -f /etc/lighttpd/lighttpd.conf ]  && { sudo mv /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf.org ; echo $configDir/lighttpd/lighttpd.con ;sudo ln -s $configDir/lighttpd/lighttpd.conf /etc/lighttpd ; }
[ ! -h /etc/lighttpd/conf-enabled/10-accesslog.conf ] && sudo ln -s $configDir/lighttpd/conf-enabled/10-accesslog.conf /etc/lighttpd/conf-enabled
[ ! -h /etc/lighttpd/conf-enabled/10-dir-listing.conf ] && sudo ln -s $configDir/lighttpd/conf-enabled/10-dir-listing.conf /etc/lighttpd/conf-enabled
[ ! -h /etc/lighttpd/conf-enabled/10-cgi.conf ] && sudo ln -s $configDir/lighttpd/conf-enabled/10-cgi.conf /etc/lighttpd/conf-enabled


