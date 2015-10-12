# Introduction

This package is meant to simplify the setup and configuration of remotely taking still pictures from a Raspberry Pi computer, connected to a Canon 7D.




Requrements:

* gphoto2
* imagemagick
* lighttpd (the setup will overwrite any current configuration)
* php5 php5-sqlite php5-cgi php5-cli php5-rrd
* php Composer

## Installation and Setup

```
sudo update-alternatives --set editor /usr/bin/vim.tiny
git clone https://github.com/maglub/piCanon.git
cd piCanon
./setup.sh
```

# References

