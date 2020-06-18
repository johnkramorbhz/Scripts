# Linux Setup Scripts
These are individual scripts for each Linux distribution that I use.

To make things simple, I just divide them into several scripts for different types of Linux distro.

To install NVIDIA drivers only, run `./ubuntu_setup.sh --nvidia--driver--only` as root or sudo.

Upgrade nodejs to the latest LTS and force update `pip3` and `apt` packages: `wget -O upgrade_all.sh https://github.com/johnkramorbhz/Scripts/raw/master/deployment/linux_setup/upgrade_all.sh && chmod u+x upgrade_all.sh && sudo ./upgrade_all.sh`

## httpd setup script usage for CentOS

`python3 genreate_httpd_config.py --single domains.com centos`

Mass mode  `python3 genreate_httpd_config.py --bulk domains.txt centos`

## apache2 setup script usage for Ubuntu

`python3 genreate_httpd_config.py --single domains.com Ubuntu`

Mass mode  `python3 genreate_httpd_config.py --bulk domains.txt Ubuntu`

## Important notice
If you want pintos binaries, you have to use 18.04 LTS instead of anything newer than 18.04 LTS that are supported right now, because Ubuntu dropped `i386` packages in 2019.

So the `cse421.sh` will only work with Ubuntu 18.04 LTS(Bionic Beaver). If you are intent to use this script anyway, you probably already know what you are doing and you probably already inspecting this script.

## What are these?
`ubuntu_setup.sh` is the Ubuntu 18.04 install script, which is the first Ubuntu LTS distribution that I support.

`ubuntu_focal_fossa.sh` is the Ubuntu 20.04 install script, and starting onwards I will name them by their code name instead of enlarging `ubuntu_setup.sh`

`cse421.sh` is a mini script that only setup the `pintos` environment used by many OS classes around the universities. 