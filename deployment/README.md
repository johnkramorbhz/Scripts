# Deployment Scripts
`linux_setup` is where I setup those coding environment in Linux environments

`management` is where I save the common diagnostic script for my Ubuntu setup.

It only supports Ubuntu LTS releases for auto setup. Currently, it supports `18.04` and `20.04`.

**If shell is not working, please make sure your endline character is set to `LF`**

## Supported distros

Ubuntu 18.04 & 20.04 for client deployment. CentOS 8 for server deployment.

CentOS 8 is in beta support as of now. CentOS 8 is a SERVER deployment script.

## Ubuntu 20.04 LTS & ROS or NVIDIA CUDA

This problem only seem to occur in 20.04 LTS, since the bash shell handles users differently. The 18.04 LTS is NOT affected.

If you cannot see their environment variables, run the following again as yourself(not root) to fix the problem.

```bash
# Only copy this one if you have NVIDIA graphics card installed whether it is in WSL or non-VM.
echo 'export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}' >> ~/.bashrc

echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
source ~/.bashrc
```

## How to run this script
Intel GPUs, [certain NVIDIA GPUs](https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus), AMD GPUs, and WSL2 on Windows 10 (21H2 or later) / Windows 11 `wget -O entry.sh https://github.com/johnkramorbhz/Scripts/raw/main/deployment/entry.sh && sudo bash entry.sh`

All other NVIDIA GPUs that require NVIDIA Proprietary Driver (This option is no longer available Ubuntu 22.04 and above) `wget -O entry.sh https://github.com/johnkramorbhz/Scripts/raw/main/deployment/entry.sh && sudo bash entry.sh --nvidia`

WSL & WSL2 without GUI applications `wget -O entry.sh https://github.com/johnkramorbhz/Scripts/raw/main/deployment/entry.sh && sudo bash entry.sh --no-GUI`

## If you have older setup scripts that installs older `nodejs`, use the following command to upgrade to the latest LTS.

`wget -O upgrade_nodejs.sh https://github.com/johnkramorbhz/Scripts/raw/main/deployment/linux_setup/upgrade_all.sh && sudo bash upgrade_nodejs.sh`

## Note

If a distro has less than 1 year of to its EOL, I will put a warning and 15 second delay. If a distro is EOL, then user need to manually continue.

Once 20.04 hits maturity, the deployment of 18.04 script will move to maintaince mode. If 22.04 hits maturity, then it will be the same case with 20.04 and so on.