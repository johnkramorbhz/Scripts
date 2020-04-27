# Scripts
These are individual scripts for each Linux distribution that I use.

To make things simple, I just divide them into several scripts for different types of Linux distro.

To install NVIDIA drivers only, run `./ubuntu_setup.sh --nvidia--driver--only` as root or sudo.

## Important notice
If you want pintos binaries, you have to use 18.04 LTS instead of anything newer than 18.04 LTS that are supported right now, because Ubuntu dropped `i386` packages in 2019.

So the `cse421.sh` will only work with Ubuntu 18.04 LTS(Bionic Beaver).

## What are these?
`ubuntu_setup.sh` is the Ubuntu 18.04 install script, which is the first Ubuntu LTS distribution that I support.

`ubuntu_focal_fossa.sh` is the Ubuntu 20.04 install script, and starting onwards I will name them by their code name instead of enlarging `ubuntu_setup.sh`