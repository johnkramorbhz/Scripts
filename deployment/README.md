# Deployment Scripts
`linux_setup` is where I setup those coding environment in Linux environments

`management` is where I save the common diagnostic script for my Ubuntu setup.

It only supports Ubuntu LTS releases for auto setup. Currently, it supports `18.04` and `20.04`.

**If shell is not working, please make sure your endline character is set to `LF`**

## Supported distros

Ubuntu 18.04 & 20.04 for client deployment. CentOS 8 for server deployment.

CentOS 8 is in beta support as of now. CentOS 8 is a SERVER deployment script.

## Ubuntu 20.04 LTS & ROS

This problem only seem to occur in 20.04 LTS, since the bash shell handles users differently. The 18.04 LTS is NOT affected.

If you cannot see the ROS environment variables, run the following again to fix the problem.

```bash
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
source ~/.bashrc
```

## How to run this script
Intel and AMD Display Adapter `wget -O entry.sh https://github.com/johnkramorbhz/Scripts/raw/main/deployment/entry.sh && sudo bash entry.sh`

NVIDIA Display Adapter `wget -O entry.sh https://github.com/johnkramorbhz/Scripts/raw/main/deployment/entry.sh && sudo bash entry.sh --nvidia`

WSL & WSL2 `wget -O entry.sh https://github.com/johnkramorbhz/Scripts/raw/main/deployment/entry.sh && sudo sudo bash entry.sh --no-GUI`

## If you have older setup scripts that installs older `nodejs`, use the following command to upgrade to the latest LTS.

`wget -O upgrade_nodejs.sh https://github.com/johnkramorbhz/Scripts/raw/main/deployment/linux_setup/upgrade_all.sh && sudo bash upgrade_all.sh`

## Note

If a distro has less than 1 year of to its EOL, I will put a warning and 15 second delay. If a distro is EOL, then user need to manually continue.

Once 20.04 hits maturity, the deployment of 18.04 script will move to maintaince mode. If 22.04 hits maturity, then it will be the same case with 20.04 and so on.