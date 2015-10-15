# Introduction

This package is meant to simplify the setup and configuration of remotely taking still pictures from a Raspberry Pi computer, connected to a Canon 7D.

Requrements:

* gphoto2
* imagemagick
* perlmagick
* lighttpd (the setup.sh script will overwrite the current configuration)
* PHP packages: php5 php5-sqlite php5-cgi php5-cli php5-rrd
* php Composer

## Usage

* Access piCanon through the web interface on your raspberry pi's IP address
* The piCanon will take a picture and store it in the ~/piCanon/save directory.
* Thumbnails are created by running ~/piCanon/bin/genThumbnails
* Snapshots can be done in multiple ways:
  * Click the "snap" link on the main webpage
  * Run the ~/piCanon/bin/snap script
  * Call the REST API: http://your.ip.address/api/snap


Example (replace localhost with the rasperry pi's IP address if you run this on a different host):

```
pi@raspberrypi ~/piCanon $ curl http://localhost/api/snap

{"msg":"ok","filename":"20151015_115317.jpg\n"}
```

# Installation and Setup

Setup will install the necessary packages and set up the lighttpd web server. Note that this setup procedure will replace any existing lighttpd configuration, so you might want to save the current configuration somewhere if you have done something important with it.

The setup script will also download any php dependencies using composer, and give the web server user www-data sudo permissions to run the "snap" script as the user "pi".

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
