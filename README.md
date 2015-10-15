# Introduction

This package is meant to simplify the setup and configuration of remotely taking still pictures from a Raspberry Pi computer, connected to a Canon 7D.

Requrements:

* gphoto2
* imagemagick
* lighttpd (the setup will overwrite any current configuration)
* php5 php5-sqlite php5-cgi php5-cli php5-rrd
* php Composer

# Installation and Setup

Setup will install the necessary packages and set up the lighttpd web server. Note that this setup procedure will replace any existing lighttpd configuration, so you might want to save the current configuration somewhere if you have done something important with it.

The setup script will also download any php dependencies using composer.

```
sudo update-alternatives --set editor /usr/bin/vim.tiny
git clone https://github.com/maglub/piCanon.git
cd piCanon
./setup.sh
```

# References

* http://www.gphoto.org/
* https://github.com/gphoto/gphoto2
* http://www.slimframework.com/
* http://startbootstrap.com/template-overviews/sb-admin-2/
