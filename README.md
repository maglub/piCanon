# Introduction

This package is meant to simplify the setup and configuration of remotely taking still pictures from a Raspberry Pi computer, connected to a Canon 7D or any other camera supported by gphoto2.

Get this repo:

```
git clone https://github.com/maglub/piSnapper.git
cd piSnapper
./setup.sh
```


Requrements:

* gphoto2
* imagemagick
* perlmagick
* lighttpd (the setup.sh script will overwrite the current configuration)
* PHP packages: php5 php5-sqlite php5-cgi php5-cli php5-rrd
* php Composer

# Usage

* Access piSnapper through the web interface on your raspberry pi's IP address
* The piSnapper will take a picture and store it in the ~/piSnapper/save directory.
* Thumbnails are created by running ~/piSnapper/bin/genThumbnails
* Snapshots can be done in multiple ways:
  * Click the "snap" link on the main webpage
  * Run the ~/piSnapper/bin/snap script
  * Call the REST API: http://your.ip.address/api/snap
* Timelapses can be set up in cron (in intervals divisible by 60 seconds or 60 minutes, i.e 5 seconds, not 7 seconds. 180 seconds, not 190 seconds, due to limitations in cron)


## Examples
* Make a snapshot through the REST API (replace localhost with the rasperry pi's IP address if you run this on a different host):

```
pi@raspberrypi ~/piSnapper $ curl http://localhost/api/snap
{"msg":"ok","filename":"20151015_115317.jpg\n"}
```

* Generate a crontab that snaps an image every 30 minutes (1800 seconds):

```
bin/wrapper setCrontab 1800 ; crontab -l
...
*/30 * * * * b=/home/pi/piSnapper/bin ; st=0 ; sleep $st ; $b/snap >> /var/log/piSnapper.log 2>&1 ; [ $st -eq 0 ] && $b/genThumbnails > /dev/null 2>&1 # XXX_PISNAPPER_XXX
```

# Installation and Setup

Setup will install the necessary packages and set up the lighttpd web server. Note that this setup procedure will replace any existing lighttpd configuration, so you might want to save the current configuration somewhere if you have done something important with it.

The setup script will also download any php dependencies using composer, and give the web server user www-data sudo permissions to run the "snap" script as the user "pi".

```
sudo update-alternatives --set editor /usr/bin/vim.tiny
git clone https://github.com/maglub/piSnapper.git
cd piSnapper
./setup.sh
```

# References

* http://www.gphoto.org/
* https://github.com/gphoto/gphoto2
* http://www.slimframework.com/
* http://startbootstrap.com/template-overviews/sb-admin-2/
